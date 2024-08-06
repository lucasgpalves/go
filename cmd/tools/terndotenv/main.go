/*package main

import (
	"os/exec"

	"github.com/joho/godotenv"
)

func main() {
	if err := godotenv.Load(); err != nil {
		panic(err)
	}

	cmd := exec.Command(
		"tern",
		"migrate",
		"--migrations",
		"./internal/store/pgstore/migrations",
		"--config",
		"./internal/store/pgstore/migrations/tern.conf",
	)

	if err := cmd.Run(); err != nil {
		panic(err)
	}
}
*/

package main

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"

	"github.com/joho/godotenv"
)

func main() {
	// Carregar variáveis de ambiente do arquivo .env
	if err := godotenv.Load(); err != nil {
		fmt.Printf("Erro ao carregar o arquivo .env: %v\n", err)
		os.Exit(1)
	}

	// fmt.Print(os.Getenv("WS_DATABASE_PORT"))

	// Defina o comando que será executado
	cmd := exec.Command(
		"tern",
		"migrate",
		"--migrations",
		"./internal/store/pgstore/migrations",
		"--config",
		"internal/store/pgstore/migrations/tern.conf",
	)

	// Capturar saída padrão e erro padrão
	var outBuf, errBuf bytes.Buffer
	// cmd.Stdout = &outBuf
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	// cmd.Stderr = &errBuf

	// Execute o comando
	if err := cmd.Run(); err != nil {
		fmt.Printf("Erro ao executar o comando: %v\n", err)
		fmt.Printf("Saída do comando: %s\n", outBuf.String())
		fmt.Printf("Erro do comando: %s\n", errBuf.String())
		os.Exit(1)
	}

	fmt.Println("Migração concluída com sucesso!")
}
