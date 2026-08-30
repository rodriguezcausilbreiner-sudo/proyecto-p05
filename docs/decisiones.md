# Decisiones técnicas · P5 Mapa colaborativo de ruido

> Plantilla de partida. Cada umbral debe sustentarse con datos reales tomados
> durante las pruebas de campo del equipo (semana 5 del cronograma), no con
> valores supuestos. Reemplacen los `[POR COMPLETAR]` con sus propias
> mediciones antes de la entrega.

## 1. Tamaño de celda geográfica (~110 m)

Se redondea la coordenada a 3 decimales (`ROUND(latitud::numeric, 3)`), lo
que agrupa muestras en una cuadrícula de aproximadamente 111 m en el eje de
latitud (constante en toda la Tierra) y algo menos en longitud según la
latitud del centro de formación. Se eligió este tamaño porque:

- Es suficientemente pequeño para distinguir zonas contiguas del campus
  (patio vs. taller vs. cafetería).
- Es suficientemente grande para juntar varias caminatas distintas y
  alcanzar el umbral de 5 muestras por celda (RF-06) en una sola sesión de
  prácticas.

`[POR COMPLETAR]`: ¿cuántas celdas distintas se poblaron en su prueba de
campo con cuántos metros recorridos?

## 2. Umbral mínimo de muestras por celda (5)

Definido en el enunciado (RF-06) y aplicado en la vista `mapa_ruido` con
`HAVING COUNT(*) >= 5`. Con menos de 5 muestras, una sola lectura anómala
(por ejemplo, un grito cerca del micrófono) distorsiona el promedio de la
celda sin que haya forma de detectarlo como atípico.

## 3. `distanceFilter` del GPS (15 m)

Se usa `LocationSettings(distanceFilter: 15)` para no recalcular posición en
cada paso: caminar genera lecturas de GPS con ruido de 1-3 m que no aportan
precisión adicional a una celda de ~110 m, pero sí consumen batería si se
consultan constantemente.

`[POR COMPLETAR]`: en su equipo de prueba, ¿qué autonomía de batería
observaron con distanceFilter en 15 m frente a un valor menor, por ejemplo 5 m?

## 4. Precisión máxima aceptada de GPS (40 m)

Una muestra sin coordenada confiable no aporta al mapa y puede ubicar el
ruido en la celda equivocada. Se descarta toda lectura con
`accuracy > 40` metros (ver `MedidorRuido._procesarAmplitud`).

`[POR COMPLETAR]`: ¿qué porcentaje de lecturas se descartó por este filtro
dentro de un edificio vs. al aire libre en su prueba?

## 5. Umbral de batería para suspender la captura (15 %)

Definido en el enunciado (RF-03). Se implementa escuchando
`Battery().onBatteryStateChanged` y verificando el nivel en cada cambio de
estado, no con un `Timer` periódico, para no gastar batería adicional solo
en preguntarle al sistema cuánta batería queda.

## 6. Tamaño de lote de envío (20 muestras)

Definido en el enunciado (RF-04). Enviar una petición HTTP por muestra
(cada 3 segundos aproximadamente) generaría decenas de peticiones por
minuto y saturaría la red del laboratorio si varios aprendices caminan a la
vez. Un lote de 20 equivale a aproximadamente 1 minuto de captura continua.

## 7. Limitación de calibración del micrófono (honestidad científica)

**El nivel reportado (`nivelDb`) es dBFS (decibelios relativos al máximo
del conversor analógico-digital del micrófono), no dB SPL (nivel de presión
sonora absoluto).** Un celular de gama baja y uno de gama alta reportarán
valores distintos para el mismo sonido real, porque la ganancia y la
sensibilidad del micrófono varían por fabricante.

Para aproximar un valor absoluto sería necesario calibrar cada equipo
contra un sonómetro de referencia y aplicar una constante de corrección por
dispositivo — algo fuera del alcance de esta actividad. El equipo **no debe
presentar los valores de `nivelDb` como decibelios SPL reales** en el
informe ni en la sustentación.

`[POR COMPLETAR]`: si el equipo intentó una calibración aproximada, describir
contra qué instrumento y con qué constante.

## 8. Qué se probó en un equipo de gama baja

`[POR COMPLETAR]`: descripción del equipo usado, síntomas observados
(demoras, descartes de muestra por batería o precisión, etc.) y ajustes que
se hicieron a partir de esa prueba.
