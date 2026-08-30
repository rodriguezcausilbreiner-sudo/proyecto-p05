import { test } from 'node:test';
import assert from 'node:assert/strict';
import { loteSchema } from '../src/servicios/validacion.js';

function muestraValida(overrides = {}) {
  return {
    nivelDb: -42.5,
    latitud: 4.6486,
    longitud: -74.0844,
    precisionM: 12,
    medidoEn: new Date().toISOString(),
    ...overrides,
  };
}

test('acepta un lote válido de hasta 20 muestras', () => {
  const lote = {
    sesionId: crypto.randomUUID(),
    muestras: Array.from({ length: 20 }, () => muestraValida()),
  };
  assert.doesNotThrow(() => loteSchema.parse(lote));
});

test('rechaza lotes de más de 20 muestras (RF-04)', () => {
  const lote = {
    sesionId: crypto.randomUUID(),
    muestras: Array.from({ length: 21 }, () => muestraValida()),
  };
  assert.throws(() => loteSchema.parse(lote));
});

test('rechaza nivelDb positivo (dBFS nunca supera 0)', () => {
  const lote = {
    sesionId: crypto.randomUUID(),
    muestras: [muestraValida({ nivelDb: 5 })],
  };
  assert.throws(() => loteSchema.parse(lote));
});

test('rechaza sesionId que no sea UUID', () => {
  const lote = { sesionId: 'no-es-uuid', muestras: [muestraValida()] };
  assert.throws(() => loteSchema.parse(lote));
});
