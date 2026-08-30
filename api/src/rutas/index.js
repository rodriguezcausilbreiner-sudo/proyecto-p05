import { Router } from 'express';
import { crearSesion } from '../controladores/sesiones.js';
import { subirLote } from '../controladores/muestras.js';
import { consultarMapa } from '../controladores/mapa.js';

const router = Router();

router.post('/sesiones', crearSesion);
router.post('/muestras/lote', subirLote);
router.get('/mapa', consultarMapa);

export default router;
