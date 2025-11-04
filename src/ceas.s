    ORG $FE10   ; Origin statement - 65040 (0fe10h)

    di
    ld hl,0fcf8h
    ld bc,00110h


    ORG $F7F7   ; Origin statement - 63479 (0f7f7h)
    
    push ix
    push af
    push bc
    push de
    push hl
    ld a,(0f8b2h)   ; TODO set as variable



END_PROGRAM:
    
