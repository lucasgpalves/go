# Usar uma imagem base com Go 1.22 pré-instalado
FROM golang:1.22 AS build

# Diretório de trabalho dentro do contêiner
WORKDIR /app

# Copiar o código-fonte para o contêiner
COPY . .

# Baixar dependências e compilar o código
RUN go mod download
RUN go build -o myapp cmd/tools/terndotenv/main.go

# Instalar tern
RUN go install github.com/jackc/tern@latest

# Usar uma imagem base mais leve para a execução do contêiner
FROM debian:bullseye-slim

# Diretório de trabalho no contêiner final
WORKDIR /app

# Instalar dependências necessárias
RUN apt-get update && apt-get install -y ca-certificates

# Copiar o binário compilado do estágio de build
COPY --from=build /app/myapp .

# Copiar o binário do tern do estágio de build
COPY --from=build /go/bin/tern /usr/local/bin/tern

# Copiar o arquivo .env para o contêiner
COPY .env .

# Comando para executar o aplicativo
CMD ["./myapp"]
