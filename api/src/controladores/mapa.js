import { mapaQuerySchema } from '../servicios/validacion.js';
import { obtenerCeldas } from '../servicios/mapaRuido.js';

export async function consultarMapa(req, res, next) {
  try {
    const filtros = mapaQuerySchema.parse(req.query);
    const celdas = await obtenerCeldas(filtros);
    res.status(200).json({ celdas, total: celdas.length });
  } catch (err) {
    next(err);
  }
}
