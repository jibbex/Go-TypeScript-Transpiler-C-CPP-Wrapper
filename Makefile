# Makefile for Go TypeScript Transpiler Wrapper

# Configuration
GO := go
BUILD_FLAGS := -buildmode=c-shared
OUTPUT_LIB := libts_transpiler.so
SRC := transpiler.go

.PHONY: all deps build clean test bench install help

all: deps build

## Install dependencies
deps:
	@$(GO) get -u github.com/evanw/esbuild/pkg/api

## Build shared library
build: deps
	@echo "Building shared library..."
	@$(GO) build $(BUILD_FLAGS) -o $(OUTPUT_LIB) $(SRC)
	@echo "Built: $(OUTPUT_LIB)"

## Clean build artifacts
clean:
	@rm -f $(OUTPUT_LIB) libts_transpiler.h
	@echo "Cleaned build artifacts"

## Run tests
test:
	@$(GO) test -v ./...

## Run benchmarks
bench:
	@$(GO) test -bench=. -run=^$$

## Install library to system path (requires sudo)
install:
	@sudo install -m 755 $(OUTPUT_LIB) /usr/local/lib/
	@echo "Installed to /usr/local/lib"

## Show help
help:
	@echo "Available targets:"
	@awk '/^## /{sub(/## /, "", $$0); print}' $(MAKEFILE_LIST) | column -t -s:

# Enable error handling with -e
SHELL := /bin/bash -e