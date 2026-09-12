; This can be only compiled with sjasmplus now
    DEVICE ZXSPECTRUM48

    ORG $F7F7
    INCLUDE "routine2.asm"     ; the IM2 handler

    ORG $FE10
    INCLUDE "routine1.asm"     ; the installer

    SAVESNA "build/ceas.sna", $FE10
