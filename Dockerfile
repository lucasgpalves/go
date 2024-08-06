# Usar uma imagem base com Go pré-instalado
FROM golang:1.21 AS build

# Diretório de trabalho dentro do contêiner
WORKDIR /app

# Copiar o código-fonte para o contêiner
COPY . .

# Baixar dependências e compilar o código
RUN go mod download
RUN go install github.com/jackc/tern/v2@latest
RUN go build -o myapp cmd/tools/terndotenv/main.go

# Usar uma imagem base mais leve para a execução do contêiner
FROM debian:bullseye-slim

# Diretório de trabalho no contêiner final
WORKDIR /app

# Copiar o binário compilado do estágio de build
COPY --from=build /app/myapp .

# Copiar o arquivo .env para o contêiner (opcional)
# COPY .env .

# Comando para executar o aplicativo
CMD ["./myapp"]
