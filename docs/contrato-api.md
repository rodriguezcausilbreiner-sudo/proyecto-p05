# Contrato de API · P5 Mapa colaborativo de ruido

Base URL local: `http://localhost:3000/api` (o `http://10.0.2.2:3000/api`
desde el emulador Android).

## POST /api/sesiones

Abre una sesión de captura y devuelve un identificador para agrupar las
muestras de esa caminata.

**Respuesta 201**
```json
{ "sesionId": "3f1c2b5e-...", "creadaEn": "2026-08-29T15:00:00.000Z" }
```

## POST /api/muestras/lote

Sube un lote de hasta 20 muestras (RF-04). Rechaza el lote completo si
alguna muestra no cumple la validación (no hay escritura parcial).

**Body**
```json
{
  "sesionId": "3f1c2b5e-...",
  "muestras": [
    {
      "nivelDb": -35.2,
      "latitud": 4.6486,
      "longitud": -74.0844,
      "precisionM": 8.5,
      "medidoEn": "2026-08-29T15:01:03.000Z"
    }
  ]
}
```

| Código | Significado |
|---|---|
| 201 | Lote insertado. Responde `{ "insertadas": <n> }` |
| 400 | Error de validación (ver `detalles`) |

## GET /api/mapa

Devuelve las celdas agregadas (RF-05). Solo celdas con 5 o más muestras
(RF-06) — nunca muestras individuales.

**Query params opcionales**: `minLat`, `maxLat`, `minLon`, `maxLon` (recorte
por bounding box para no descargar el mapa completo en pantallas pequeñas).

**Respuesta 200**
```json
{
  "celdas": [
    { "celdaLat": 4.649, "celdaLon": -74.084, "promedioDb": -32.1, "maximoDb": -18.4, "muestras": 12 }
  ],
  "total": 1
}
```

## GET /salud

Chequeo simple de disponibilidad del servicio. Responde `{ "estado": "ok" }`.
