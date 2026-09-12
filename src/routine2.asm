    org $F7F7               ; 63479

HOURS_TICK  equ $F8B2       ; 63666 - interrupt divider, reloaded to 50 (0x32) each rollover
HOURS       equ $F8B3       ; 63667
MINUTES     equ $F8B4       ; 63668 (BASIC listing shows "64668" - almost certainly an OCR
                             ;         misread of 63668, given it clusters with 63666/67/69)
SECONDS     equ $F8B5       ; 63669

START:
    push ix
    push af
    push bc
    push de
    push hl
    ld a,(HOURS_TICK)
    dec a
    ld (HOURS_TICK),a
    jp nz,DONE
    ld a,$32
    ld (HOURS_TICK),a
    ld a,(SECONDS)
    and a
    adc a,$01
    daa
    ld (SECONDS),a
    cp $60
    jp nz,DONE
    xor a
    ld (SECONDS),a
    ld a,(MINUTES)
    and a
    adc a,$01
    daa
    ld (MINUTES),a
    cp $60
    jp nz,DONE
    xor a
    ld (MINUTES),a
    ld a,(HOURS)
    and a
    adc a,$01
    daa
    ld (HOURS),a
    cp $13                  ; TODO: verify against scan - expected a day-rollover
                             ;       value here (e.g. $24 for 24h), $13 looks odd
    jp nz,DONE
    ld a,$01
    ld (HOURS),a

DONE:
    ld ix,$4018
    ld a,(HOURS)
    call CONV_PRINT
    ld a,$0A
    call PRINT_DIGIT
    ld a,(MINUTES)
    call CONV_PRINT
    ld a,$0A
    call PRINT_DIGIT
    ld a,(SECONDS)
    call CONV_PRINT
    ld hl,$5818
    ld b,$08
CLEAR_LOOP:
    ld (hl),$C7
    inc hl
    djnz CLEAR_LOOP
    pop hl
    pop de
    pop bc
    pop af
    pop ix
    jp $0038

CONV_PRINT:                 ; splits A into two BCD nibbles, prints each
    push af
    srl a
    srl a
    srl a
    srl a
    call PRINT_DIGIT
    pop af
    and $0F
    call PRINT_DIGIT
    ret

PRINT_DIGIT:                ; plots digit glyph directly into screen bytes at IX
    push ix
    ld hl,($5C36)           ; ROM system var CHARS - font table base
    ld de,$0180
    add hl,de
    ex de,hl
    ld l,a
    ld h,$00
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,de
    ld de,$0100
    ld b,$08
BUILD_LOOP:
    ld a,(hl)
    xor $FF
    ld (ix+$00),a
    inc hl
    add ix,de
    djnz BUILD_LOOP
    pop ix
    inc ix
    ret