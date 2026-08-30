import { z } from 'zod';

// dBFS: siempre negativo o cero (0 = saturación del conversor).
const muestraSchema = z.object({
  nivelDb: z.number().max(0, 'El nivel en dBFS no puede ser mayor a 0'),
  latitud: z.number().min(-90).max(90),
  longitud: z.number().min(-180).max(180),
  precisionM: z.number().nonnegative().nullable().optional(),
  medidoEn: z.string().datetime({ offset: true }),
});

export const loteSchema = z.object({
  sesionId: z.string().uuid('sesionId debe ser un UUID válido'),
  muestras: z
    .array(muestraSchema)
    .min(1, 'El lote debe traer al menos una muestra')
    .max(20, 'El lote no puede superar 20 muestras (RF-04)'),
});

export const mapaQuerySchema = z.object({
  minLat: z.coerce.number().min(-90).max(90).optional(),
  maxLat: z.coerce.number().min(-90).max(90).optional(),
  minLon: z.coerce.number().min(-180).max(180).optional(),
  maxLon: z.coerce.number().min(-180).max(180).optional(),
});
