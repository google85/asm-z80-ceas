SRC_FILE = ceas
SRC_DIR = ./src
BUILD_DIR = ./build
SRC_IN = ${SRC_DIR}/${SRC_FILE}.s
BIN_OUT = ${BUILD_DIR}/${SRC_FILE}.out
LST_OUT = ${BUILD_DIR}/${SRC_FILE}.lst
DOCKER_IMAGE=local/vasm-dev:z80
BUILD_CC=vasm

help:
	@echo "Usage":
	@sed -n 's/^##//p' ${MAKEFILE_LIST} |  sed -e 's/^/ /'

## dev: Enter Docker development environment
dev: docker-img-build
	docker run --rm -it -v .:/app --name vasm-depl-z80 -w /app  ${DOCKER_IMAGE}

docker-img-build:
	docker build -t ${DOCKER_IMAGE} .

## build: Build the application
build:
	@mkdir -p ${BUILD_DIR} && chown 1000:1000 ${BUILD_DIR}
#	${BUILD_CC} -Fbin -dotdir ${SRC_IN} -o ${BIN_OUT}
	${BUILD_CC} -Fbin -L ${LST_OUT} -dotdir ${SRC_IN} -o ${BIN_OUT}
	hexdump -C ${BIN_OUT}

create-build-dir:
	@mkdir -p ${BUILD_DIR}

## disass: Generate ASCII binaries from hex values
generate-bin: create-build-dir
	@echo -n "F321F8FC01100136F7230B78B120F83EFDED47ED5EFBC9000000" \
	| perl -pe 's/([0-9A-Fa-f]{2})/chr(hex($$1))/eg' \
 	> ${BUILD_DIR}/ceas65040.bin
	@echo -n "DDE5F5C5D5E53AB2F83D32B2F8C246F83E3232B2F83AB5F8A7CE012732B5F8FE60C246F8AF32B5F83AB4F8A7CE012732B4F8FE60C246F8AF32B4F83AB3F8A7CE012732B3F8FE13C246F83E0132B3F8DD2118403AB3F8CD79F83E0ACD8CF83AB4F8CD79F83E0ACD8CF83AB5F8CD79F8211858060836C72310FBE1D1C1F1DDE1C33800F5CB3FCB3FCB3FCB3FCD8CF8F1E60FCD8CF8C9DDE52A365C11800119EB6F26002929291911000106087EEEFFDD770023DD1910F5DDE1DD23C9" \
	| perl -pe 's/([0-9A-Fa-f]{2})/chr(hex($$1))/eg' \
 	> ${BUILD_DIR}/ceas63479.bin

## disass: Disassemble binary files into .lst assembly listings
disass:
	z80dasm -z -a -l -t -g 0xFE10 ${BUILD_DIR}/routine1_65040.bin > ${BUILD_DIR}/routine1_65040.lst
	z80dasm -z -a -l -t -g 0xF7F7 ${BUILD_DIR}/routine2_63479.bin > ${BUILD_DIR}/routine2_63479.lst

## clean: Clean-up the build binaries
clean:
	@echo "Cleaning up..."
	@rm -rf ${BUILD_DIR}

.PHONY: help dev docker-img-build build generate-bin disass clean