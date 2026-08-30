import { PrismaClient } from '@prisma/client';

// Singleton: evita abrir un pool de conexiones nuevo en cada import,
// especialmente relevante con --watch en desarrollo.
const prisma = new PrismaClient();

export default prisma;
