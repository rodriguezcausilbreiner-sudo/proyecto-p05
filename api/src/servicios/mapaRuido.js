import prisma from '../prisma/cliente.js';
import { Prisma } from '@prisma/client';

// La agregación vive en la base de datos (vista mapa_ruido), no en el
// cliente ni en JavaScript: el motor tiene los índices y escala mejor
// que sumar en memoria miles de filas descargadas por la red.
export async function obtenerCeldas({ minLat, maxLat, minLon, maxLon }) {
  const condiciones = [Prisma.sql`1 = 1`];

  if (minLat !== undefined) condiciones.push(Prisma.sql`celda_lat >= ${minLat}`);
  if (maxLat !== undefined) condiciones.push(Prisma.sql`celda_lat <= ${maxLat}`);
  if (minLon !== undefined) condiciones.push(Prisma.sql`celda_lon >= ${minLon}`);
  if (maxLon !== undefined) condiciones.push(Prisma.sql`celda_lon <= ${maxLon}`);

  const filtro = Prisma.join(condiciones, ' AND ');

  const celdas = await prisma.$queryRaw`
    SELECT celda_lat AS "celdaLat",
           celda_lon AS "celdaLon",
           promedio_db AS "promedioDb",
           maximo_db AS "maximoDb",
           muestras
    FROM mapa_ruido
    WHERE ${filtro}
    ORDER BY muestras DESC
  `;

  // BigInt / Decimal no serializan directo a JSON.
  return celdas.map((c) => ({
    celdaLat: Number(c.celdaLat),
    celdaLon: Number(c.celdaLon),
    promedioDb: Number(c.promedioDb),
    maximoDb: Number(c.maximoDb),
    muestras: Number(c.muestras),
  }));
}
