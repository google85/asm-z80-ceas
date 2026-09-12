    org $FE10       ; 65040
    di
    ld hl,$FCF8
    ld bc,$0110

LABEL_65047:
    ld (hl),$F7
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,LABEL_65047
    ld a,$FD
    ld i,a
    im 2
    ei
    ret
    nop
    nop
    nop