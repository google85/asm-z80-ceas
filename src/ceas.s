    ORG $FE10   ; Origin statement - 65040 (0fe10h)

    di
    ld hl,0fcf8h
    ld bc,00110h

    ORG $FE17   ; 65047
LABEL_65047:
    ld (hl),0f7h
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,LABEL_65047
    ld a,0fdh
    ld i,a
    im 2                ; interrupts mode 2
    ei
    ret
    nop
    nop
    nop

    ; .............



    ORG $F7F7   ; Origin statement - 63479 (0f7f7h)
    
    push ix
    push af
    push bc
    push de
    push hl
    ld a,(0f8b2h)   ; 63666 - TODO set as variable
    dec a
    ld (0f8b2h),a   ; 63666 - TODO set as variable
    jp nz,LABEL_63558
    ld a,032h
    ld (LABEL_63558),a
    ld a,(LABEL_63669)

    ORG $F846   ; 63558
LABEL_63558:

    ORG $F8B5   ; 63669
LABEL_63669:


END_PROGRAM:
    
