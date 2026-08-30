import { randomUUID } from 'node:crypto';

// No hay tabla de sesiones en el modelo de datos: sesionId es solo una
// etiqueta de agrupación que el cliente adjunta a cada muestra para poder
// filtrar o depurar una caminata concreta si hace falta.
export function crearSesion(req, res) {
  res.status(201).json({ sesionId: randomUUID(), creadaEn: new Date().toISOString() });
}
