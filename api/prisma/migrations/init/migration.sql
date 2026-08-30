-- P5 · Mapa colaborativo de ruido
-- Tabla base + columnas generadas (celda geográfica ~110 m) + vista agregada.

CREATE TABLE muestra_ruido (
  id BIGSERIAL PRIMARY KEY,
  sesion_id UUID NOT NULL,
  nivel_db REAL NOT NULL,
  latitud DOUBLE PRECISION NOT NULL,
  longitud DOUBLE PRECISION NOT NULL,
  precision_m REAL,
  medido_en TIMESTAMPTZ NOT NULL,
  celda_lat NUMERIC(7,3) GENERATED ALWAYS AS (ROUND(latitud::numeric, 3)) STORED,
  celda_lon NUMERIC(7,3) GENERATED ALWAYS AS (ROUND(longitud::numeric, 3)) STORED
);

CREATE INDEX idx_celda ON muestra_ruido (celda_lat, celda_lon);
CREATE INDEX idx_muestra_fecha ON muestra_ruido (medido_en DESC);

-- El cliente nunca descarga muestras crudas: solo celdas agregadas.
CREATE VIEW mapa_ruido AS
SELECT celda_lat,
       celda_lon,
       ROUND(AVG(nivel_db)::numeric, 1) AS promedio_db,
       MAX(nivel_db) AS maximo_db,
       COUNT(*) AS muestras
FROM muestra_ruido
GROUP BY celda_lat, celda_lon
HAVING COUNT(*) >= 5;
