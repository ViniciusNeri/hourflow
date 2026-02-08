# Estágio 1: Build
FROM cirrusci/flutter:stable AS build-env

RUN flutter doctor
RUN mkdir /app
WORKDIR /app
COPY . .
RUN flutter build web --release

# Estágio 2: Servir os arquivos
FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]