; Chapter 17 Exercise 1
; Called by ex1v2.c
;
; void ascii_to_ebcdic(unsigned char *ascii,unsigned char *ebcdic,long length);
; void ebcdic_to_ascii(unsigned char *ascii,unsigned char *ebcdic,long length);

global ascii_to_ebcdic,ebcdic_to_ascii

; ascii_to_ebcdic converts an ascii string to an ebcdic one.
; Arguments:
; rdi pointer to source array of ascii characters
; rsi pointer to target array of ebcdic characters
; rdx length of source string and arrays
; Variables:
; r8 - current byte offset into both arrays
; al - source byte
; cl - target byte
; r9 - pointer to to_ebcdic table

segment .text

ascii_to_ebcdic:	         
    push rbp                     
    mov rbp,rsp
    xor r8,r8                    ; clear byte offset - 0
    lea r9,[to_ebcdic]           ; load pointer to table
.looptop:
    cmp r8,rdx
    jge .loopend
    xor rax,rax                  ; clear rax
    mov al,byte [rdi+r8]         ; load current source byte
    mov cl,byte [r9+rax]         ; use source byte as index into table
    mov byte [rsi+r8],cl         ; store translated byte
    inc r8                       ; next byte
    jmp .looptop     
.loopend:
    xor rax,rax                  ; return code 0
    leave                        ; fix stack
    ret                          ; return

; ebcdic_to_ascii converts an ebcdic string to an ascii one.
; Arguments:
; rdi pointer to target array of ascii characters
; rsi pointer to source array of ebcdic characters
; rdx length of source string and arrays
; Variables:
; r8 - current byte offset into both arrays
; al - source byte
; cl - target byte
; r9 - pointer to to_ascii table

segment .text

ebcdic_to_ascii:	         
    push rbp                     
    mov rbp,rsp
    xor r8,r8                    ; clear byte offset - 0
    lea r9,[to_ascii]            ; load pointer to table
.looptop:
    cmp r8,rdx
    jge .loopend
    xor rax,rax                  ; clear rax
    mov al,byte [rsi+r8]         ; load current source byte
    mov cl,byte [r9+rax]         ; use source byte as index into table
    mov byte [rdi+r8],cl         ; store translated byte
    inc r8                       ; next byte
    jmp .looptop     
.loopend:
    xor rax,rax                  ; return code 0
    leave                        ; fix stack
    ret                          ; return
    
; Putting ascii and ebcdic tables at end so they don't clutter up the beginning of the file

segment .data

to_ebcdic:
db 0x00
db 0x01
db 0x02
db 0x03
db 0x37
db 0x2D
db 0x2E
db 0x2F
db 0x16
db 0x05
db 0x25
db 0x0B
db 0x0C
db 0x0D
db 0x0E
db 0x0F
db 0x10
db 0x11
db 0x12
db 0x13
db 0x3C
db 0x3D
db 0x32
db 0x26
db 0x18
db 0x19
db 0x3F
db 0x27
db 0x1C
db 0x1D
db 0x1E
db 0x1F
db 0x40
db 0x4F
db 0x7F
db 0x7B
db 0x5B
db 0x6C
db 0x50
db 0x7D
db 0x4D
db 0x5D
db 0x5C
db 0x4E
db 0x6B
db 0x60
db 0x4B
db 0x61
db 0xF0
db 0xF1
db 0xF2
db 0xF3
db 0xF4
db 0xF5
db 0xF6
db 0xF7
db 0xF8
db 0xF9
db 0x7A
db 0x5E
db 0x4C
db 0x7E
db 0x6E
db 0x6F
db 0x7C
db 0xC1
db 0xC2
db 0xC3
db 0xC4
db 0xC5
db 0xC6
db 0xC7
db 0xC8
db 0xC9
db 0xD1
db 0xD2
db 0xD3
db 0xD4
db 0xD5
db 0xD6
db 0xD7
db 0xD8
db 0xD9
db 0xE2
db 0xE3
db 0xE4
db 0xE5
db 0xE6
db 0xE7
db 0xE8
db 0xE9
db 0x4A
db 0xE0
db 0x5A
db 0x5F
db 0x6D
db 0x79
db 0x81
db 0x82
db 0x83
db 0x84
db 0x85
db 0x86
db 0x87
db 0x88
db 0x89
db 0x91
db 0x92
db 0x93
db 0x94
db 0x95
db 0x96
db 0x97
db 0x98
db 0x99
db 0xA2
db 0xA3
db 0xA4
db 0xA5
db 0xA6
db 0xA7
db 0xA8
db 0xA9
db 0xC0
db 0x6A
db 0xD0
db 0xA1
db 0x07
db 0x20
db 0x21
db 0x22
db 0x23
db 0x24
db 0x15
db 0x06
db 0x17
db 0x28
db 0x29
db 0x2A
db 0x2B
db 0x2C
db 0x09
db 0x0A
db 0x1B
db 0x30
db 0x31
db 0x1A
db 0x33
db 0x34
db 0x35
db 0x36
db 0x08
db 0x38
db 0x39
db 0x3A
db 0x3B
db 0x04
db 0x14
db 0x3E
db 0xE1
db 0x41
db 0x42
db 0x43
db 0x44
db 0x45
db 0x46
db 0x47
db 0x48
db 0x49
db 0x51
db 0x52
db 0x53
db 0x54
db 0x55
db 0x56
db 0x57
db 0x58
db 0x59
db 0x62
db 0x63
db 0x64
db 0x65
db 0x66
db 0x67
db 0x68
db 0x69
db 0x70
db 0x71
db 0x72
db 0x73
db 0x74
db 0x75
db 0x76
db 0x77
db 0x78
db 0x80
db 0x8A
db 0x8B
db 0x8C
db 0x8D
db 0x8E
db 0x8F
db 0x90
db 0x9A
db 0x9B
db 0x9C
db 0x9D
db 0x9E
db 0x9F
db 0xA0
db 0xAA
db 0xAB
db 0xAC
db 0xAD
db 0xAE
db 0xAF
db 0xB0
db 0xB1
db 0xB2
db 0xB3
db 0xB4
db 0xB5
db 0xB6
db 0xB7
db 0xB8
db 0xB9
db 0xBA
db 0xBB
db 0xBC
db 0xBD
db 0xBE
db 0xBF
db 0xCA
db 0xCB
db 0xCC
db 0xCD
db 0xCE
db 0xCF
db 0xDA
db 0xDB
db 0xDC
db 0xDD
db 0xDE
db 0xDF
db 0xEA
db 0xEB
db 0xEC
db 0xED
db 0xEE
db 0xEF
db 0xFA
db 0xFB
db 0xFC
db 0xFD
db 0xFE
db 0xFF

to_ascii:
db 0x00
db 0x01
db 0x02
db 0x03
db 0x9C
db 0x09
db 0x86
db 0x7F
db 0x97
db 0x8D
db 0x8E
db 0x0B
db 0x0C
db 0x0D
db 0x0E
db 0x0F
db 0x10
db 0x11
db 0x12
db 0x13
db 0x9D
db 0x85
db 0x08
db 0x87
db 0x18
db 0x19
db 0x92
db 0x8F
db 0x1C
db 0x1D
db 0x1E
db 0x1F
db 0x80
db 0x81
db 0x82
db 0x83
db 0x84
db 0x0A
db 0x17
db 0x1B
db 0x88
db 0x89
db 0x8A
db 0x8B
db 0x8C
db 0x05
db 0x06
db 0x07
db 0x90
db 0x91
db 0x16
db 0x93
db 0x94
db 0x95
db 0x96
db 0x04
db 0x98
db 0x99
db 0x9A
db 0x9B
db 0x14
db 0x15
db 0x9E
db 0x1A
db 0x20
db 0xA0
db 0xA1
db 0xA2
db 0xA3
db 0xA4
db 0xA5
db 0xA6
db 0xA7
db 0xA8
db 0x5B
db 0x2E
db 0x3C
db 0x28
db 0x2B
db 0x21
db 0x26
db 0xA9
db 0xAA
db 0xAB
db 0xAC
db 0xAD
db 0xAE
db 0xAF
db 0xB0
db 0xB1
db 0x5D
db 0x24
db 0x2A
db 0x29
db 0x3B
db 0x5E
db 0x2D
db 0x2F
db 0xB2
db 0xB3
db 0xB4
db 0xB5
db 0xB6
db 0xB7
db 0xB8
db 0xB9
db 0x7C
db 0x2C
db 0x25
db 0x5F
db 0x3E
db 0x3F
db 0xBA
db 0xBB
db 0xBC
db 0xBD
db 0xBE
db 0xBF
db 0xC0
db 0xC1
db 0xC2
db 0x60
db 0x3A
db 0x23
db 0x40
db 0x27
db 0x3D
db 0x22
db 0xC3
db 0x61
db 0x62
db 0x63
db 0x64
db 0x65
db 0x66
db 0x67
db 0x68
db 0x69
db 0xC4
db 0xC5
db 0xC6
db 0xC7
db 0xC8
db 0xC9
db 0xCA
db 0x6A
db 0x6B
db 0x6C
db 0x6D
db 0x6E
db 0x6F
db 0x70
db 0x71
db 0x72
db 0xCB
db 0xCC
db 0xCD
db 0xCE
db 0xCF
db 0xD0
db 0xD1
db 0x7E
db 0x73
db 0x74
db 0x75
db 0x76
db 0x77
db 0x78
db 0x79
db 0x7A
db 0xD2
db 0xD3
db 0xD4
db 0xD5
db 0xD6
db 0xD7
db 0xD8
db 0xD9
db 0xDA
db 0xDB
db 0xDC
db 0xDD
db 0xDE
db 0xDF
db 0xE0
db 0xE1
db 0xE2
db 0xE3
db 0xE4
db 0xE5
db 0xE6
db 0xE7
db 0x7B
db 0x41
db 0x42
db 0x43
db 0x44
db 0x45
db 0x46
db 0x47
db 0x48
db 0x49
db 0xE8
db 0xE9
db 0xEA
db 0xEB
db 0xEC
db 0xED
db 0x7D
db 0x4A
db 0x4B
db 0x4C
db 0x4D
db 0x4E
db 0x4F
db 0x50
db 0x51
db 0x52
db 0xEE
db 0xEF
db 0xF0
db 0xF1
db 0xF2
db 0xF3
db 0x5C
db 0x9F
db 0x53
db 0x54
db 0x55
db 0x56
db 0x57
db 0x58
db 0x59
db 0x5A
db 0xF4
db 0xF5
db 0xF6
db 0xF7
db 0xF8
db 0xF9
db 0x30
db 0x31
db 0x32
db 0x33
db 0x34
db 0x35
db 0x36
db 0x37
db 0x38
db 0x39
db 0xFA
db 0xFB
db 0xFC
db 0xFD
db 0xFE
db 0xFF
