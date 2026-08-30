# P5 · Mapa colaborativo de ruido

Actividad No. 5 — SENA ADSO, ficha 3278641. Medición de presión sonora
georreferenciada con agregación estadística en base de datos.

## Estructura

```
proyecto-p05/
├── app/     # Flutter + Riverpod + Dio
├── api/     # Node.js + Express + Prisma + PostgreSQL
└── docs/    # decisiones.md, contrato-api.md
```

## Backend (`api/`)

```bash
cd api
cp .env.example .env      # edita DATABASE_URL con tus credenciales de PostgreSQL
npm install
npx prisma migrate dev    # crea la tabla, columnas generadas y la vista mapa_ruido
npm run dev                # http://localhost:3000
```

Pruebas (no requieren base de datos, validan las reglas de negocio con Zod):
```bash
npm test
```

## Frontend (`app/`)

```bash
cd app
flutter pub get
flutter run
```

Antes de correr en dispositivo físico, cambia la `baseUrl` en
`lib/core/red/cliente_dio.dart` de `10.0.2.2` (emulador) a la IP de tu
equipo en la red del laboratorio.

Pruebas que corren sin dispositivo (lógica de loteo, RF-04):
```bash
flutter test
```

## Requisitos funcionales cubiertos

| RF | Descripción | Dónde |
|---|---|---|
| RF-01 | Medir nivel de presión sonora en dBFS | `datos/servicios/medidor_ruido.dart` |
| RF-02 | Asociar cada muestra a coordenada con distanceFilter | `medidor_ruido.dart` (GestorPermisos + Geolocator) |
| RF-03 | Suspender captura con batería < 15 % | `medidor_ruido.dart` (`_subBateria`) |
| RF-04 | Enviar en lotes de 20 | `datos/servicios/loteador_muestras.dart` + `POST /api/muestras/lote` |
| RF-05 | Consultar mapa de celdas agregadas | `GET /api/mapa` + `PaginaMapa` |
| RF-06 | Ocultar celdas con menos de 5 muestras | vista SQL `mapa_ruido` (`HAVING COUNT(*) >= 5`) |

## Criterios bloqueantes — checklist antes de sustentar

- [ ] Las muestras se envían en lotes; no hay una petición HTTP por medición.
- [ ] La captura se detiene sola con batería baja y avisa al usuario.
- [ ] El endpoint del mapa devuelve celdas agregadas, nunca muestras individuales.
- [ ] `docs/decisiones.md` declara la limitación de calibración del micrófono (completar los `[POR COMPLETAR]`).
- [ ] Probado en al menos dos equipos físicos con versiones distintas de Android.
- [ ] Ninguna suscripción a sensores queda sin cancelar (verificado: `Provider.autoDispose` + `ref.onDispose` en `medidorRuidoProvider`).

## Pendiente por completar (equipo)

1. Correr `npx prisma migrate dev` contra su base de datos real y confirmar que la vista `mapa_ruido` filtra correctamente.
2. Probar en dos dispositivos físicos distintos y llenar `docs/decisiones.md` con datos reales (hay 6 campos `[POR COMPLETAR]`).
3. Ajustar `baseUrl` en `cliente_dio.dart` a la IP del ambiente.
4. Grabar mínimo 8 commits descriptivos a medida que avanzan (no todo de una vez).
5. Exportar el APK de depuración para la entrega de la semana 6.
