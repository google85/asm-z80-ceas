BUILD_DIR = ./build
SRC_IN = ./src/ceas.s
BIN_OUT = ./build/ceas.out
DOCKER_IMAGE=local/vasm-dev:z80
BUILD_CC=vasm

.PHONY: help
help:
	@echo "Usage":
	@sed -n 's/^##//p' ${MAKEFILE_LIST} |  sed -e 's/^/ /'

## dev: Enter Docker development environment
.PHONY: dev
dev: docker-img-build
	docker run --rm -it -v .:/app --name vasm-depl-z80 -w /app  ${DOCKER_IMAGE}

docker-img-build:
	docker build -t ${DOCKER_IMAGE} .

## build: Build the application
.PHONY: build
build:
	@mkdir -p ${BUILD_DIR} && chown 1000:1000 ${BUILD_DIR}
	${BUILD_CC} -Fbin -dotdir ${SRC_IN} -o ${BIN_OUT}
	hexdump -C ${BIN_OUT}

## disass: Disassemble binary file
.PHONY: disass
disass:
	z80dasm -z -a -l -t ./src/ceas65040.bin > ./build/ceas65040.lst

## clean: Clean-up the build binaries
.PHONY: clean
clean:
	@echo "Cleaning up..."
	@rm -rf ${BUILD_DIR}
