# Dockerfile del repositorio base.
# Contiene cinco malas practicas deliberadas. Cada una lleva su numero en la
# linea anterior. Corregirlas es el bloque A1 de la guia del laboratorio.


FROM node:20-alpine AS builder
WORKDIR /app


COPY package.json package-lock.json ./
RUN npm ci


COPY src ./src
RUN npm run build



FROM public.ecr.aws/lambda/nodejs:20 AS runtime


COPY --from=builder /app/dist/handler.js ${LAMBDA_TASK_ROOT}/
CMD ["handler.handler"]
