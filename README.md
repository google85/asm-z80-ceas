## Z80 Ceas - in assembly
- based on [Tehnium 10/1988](http://blog.copcea.ro/files/tehnium/revista/8810.pdf)
- using [vasm](http://sun.hasenbraten.de/vasm/index.php?view=main)
- Dockerized by me

### Usage:
> development
```bash
make dev
# compile source
make build
# show output as hex dump
hexdump -C ./build/ceas.out
```


### Notes:
> ./src/ceas.bas      - Basic source containing POKE commands for assembling
> ./src/ceas65040.bin - Hex2Ascii for data from Basic source, used for generating assmbly source code
> ./src/ceas.s        - Clean assembly source code, based on files above
