# Dockerfile del repositorio base.
# Contiene cinco malas practicas deliberadas. Cada una lleva su numero en la
# linea anterior. Corregirlas es el bloque A1 de la guia del laboratorio.

# defecto 1
FROM node:20-alpine AS builder
WORKDIR /app

# defecto 2
COPY package.json package-lock.json ./
RUN npm ci

# defecto 3
COPY src ./src
RUN npm run build

# defecto 4

FROM public.ecr.aws/lambda/nodejs:20 AS runtime

# defecto 5
COPY --from=builder /app/dist/handler.js ${LAMBDA_TASK_ROOT}/
CMD ["handler.handler"]
