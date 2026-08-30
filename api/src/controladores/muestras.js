import prisma from '../prisma/cliente.js';
import { loteSchema } from '../servicios/validacion.js';

export async function subirLote(req, res, next) {
  try {
    const { sesionId, muestras } = loteSchema.parse(req.body);

    // createMany en una sola sentencia: el lote de 20 (RF-04) llega en
    // una petición HTTP, no en veinte. skipDuplicates evita reventar
    // el lote completo si el cliente reintenta un envío parcial.
    const resultado = await prisma.muestraRuido.createMany({
      data: muestras.map((m) => ({
        sesionId,
        nivelDb: m.nivelDb,
        latitud: m.latitud,
        longitud: m.longitud,
        precisionM: m.precisionM ?? null,
        medidoEn: new Date(m.medidoEn),
      })),
    });

    res.status(201).json({ insertadas: resultado.count });
  } catch (err) {
    next(err);
  }
}
