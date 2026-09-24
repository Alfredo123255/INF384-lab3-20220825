# Dockerfile del repositorio base.
# Contiene cinco malas practicas deliberadas. Cada una lleva su numero en la
# linea anterior. Corregirlas es el bloque A1 de la guia del laboratorio.


FROM node:20-alpine AS build
WORKDIR /build

#INYECCION 1 -- inyeccion
ENV AWS_ACCESS_KEY_ID=AKIA2K7QXZM9F3RSTLPQ
ENV AWS_SECRET_ACCESS_KEY=N3xTgQ8vLpW2yHkR6bE1cZaF9dMoIuJ4sV7lKnPq

COPY package.json package-lock.json ./

RUN npm ci
COPY src ./src

### NO TOCAR DE ACA EN ADELANTE, CONSIDEREN QUE EL WORKDIR DEBE SER /build
RUN npx esbuild src/handler.js \
      --bundle --platform=node --target=node20 \
      --outfile=dist/handler.js
# Etapa final: recibe unicamente el artefacto empaquetado.
# El arbol de node_modules se queda en la etapa anterior.
FROM public.ecr.aws/lambda/nodejs:20 AS runtime
COPY --from=build /build/dist/handler.js ${LAMBDA_TASK_ROOT}/
CMD ["handler.handler"]
