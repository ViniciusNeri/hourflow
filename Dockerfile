# Estágio 1: Build
FROM debian:latest AS build-env

# Instala o básico
RUN apt-get update && apt-get install -y curl git unzip xz-utils libglu1-mesa ca-certificates

# Instala o Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Força a desativação de tudo e remove o cache do Gradle/Android que causa o erro
RUN flutter config --no-analytics && \
    flutter config --no-enable-android && \
    flutter config --no-enable-ios && \
    rm -rf /usr/local/flutter/bin/cache/artifacts/gradle_wrapper

# Prepara o diretório do app
WORKDIR /app
COPY . .

# Roda o build direto (o build web vai baixar o que precisa sem passar pelo tar do gradle)
RUN flutter pub get
RUN flutter build web --release

# Estágio 2: Servir com Nginx
FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]