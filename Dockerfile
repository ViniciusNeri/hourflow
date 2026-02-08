# Estágio 1: Build do Flutter
FROM debian:latest AS build-env

# Instala dependências necessárias
RUN apt-get update && apt-get install -y curl git unzip xz-utils libglu1-mesa

# Instala o Flutter stable
RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Roda o doctor para garantir que está tudo ok
RUN flutter doctor

# Prepara o app
RUN mkdir /app
WORKDIR /app
COPY . .

# Executa o build para web
RUN flutter build web --release

# Estágio 2: Servir com Nginx (Leve e rápido)
FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Expõe a porta 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]