#!/bin/bash

# ./api/graphql/generate-typing.sh

# Path to this plugin
PROJECT_DIR=$(pwd)
PROJECT_NAME=$(basename $(pwd))
# OUTPUT_DIR=${PROJECT_DIR}/generated/graphql
OUTPUT_DIR=${PROJECT_DIR}/graph
TOOLS_DIR=${PROJECT_DIR}/tools
echo -e "\n>>> Generating GraphQL typings for ${PROJECT_NAME} to ${OUTPUT_DIR}...\n"

rm -rf ${OUTPUT_DIR} ${TOOLS_DIR} api/graphql/generated cmd/${PROJECT_NAME}/server.go
mkdir -p ${OUTPUT_DIR} ${TOOLS_DIR}

printf '// +build tools\npackage tools\nimport (_ "github.com/99designs/gqlgen"\n _ "github.com/99designs/gqlgen/graphql/introspection")' | gofmt >tools/tools.go
go mod tidy

# go run github.com/99designs/gqlgen init --server cmd/${PROJECT_NAME}/main.go
go run github.com/99designs/gqlgen init --server cmd/${PROJECT_NAME}/server.go
# Exec "go run ./server.go" to start GraphQL server

# Generate GraphQL schema typing
rm -rf gqlgen.yml ${OUTPUT_DIR}
mkdir -p ${OUTPUT_DIR}/model
go run github.com/99designs/gqlgen generate --config api/graphql/gqlgen_manual.yml

# if [ -e cmd/${PROJECT_NAME}/main.go ]; then
#     rm -rf cmd/${PROJECT_NAME}/server.go
# fi

go generate ./...

echo "graphql typings generated successfully!"
