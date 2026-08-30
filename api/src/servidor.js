import 'dotenv/config';
import app from './app.js';

const PUERTO = process.env.PORT || 3000;

app.listen(PUERTO, () => {
  console.log(`API P5 · Mapa colaborativo de ruido escuchando en http://localhost:${PUERTO}`);
});
