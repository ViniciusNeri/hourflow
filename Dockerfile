# Estágio 1: Build
FROM debian:latest AS build-env

# Instala apenas o essencial
RUN apt-get update && apt-get install -y curl git unzip xz-utils libglu1-mesa

# Instala o Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# CONFIGURAÇÃO CRUCIAL: Desabilita tudo que não é Web para evitar downloads inúteis (e o erro do Gradle)
RUN flutter config --no-analytics
RUN flutter config --no-enable-android
RUN flutter config --no-enable-ios
RUN flutter config --no-enable-linux-desktop
RUN flutter config --no-enable-windows-desktop
RUN flutter config --no-enable-macos-desktop

# Pre-download apenas dos artefatos Web
RUN flutter precache --web

# Prepara o app
WORKDIR /app
COPY . .

# Build Web
RUN flutter pub get
RUN flutter build web --release

# Estágio 2: Servir com Nginx
FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]