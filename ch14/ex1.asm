; inserts a customer record in a file
; either sticks it in the middle if the record is empty
; or at the end.

; Non-float arguments in these registers:
; rdi, rsi, rdx, rcx, r8 and r9
; rax contains the number of floating point arguments
; xmm0 to xmm7 contain the float arguments
; These registers must be preserved across function calls:
; rbx, rsp, rbp, r12-r15
; rax and rdx are the integer return registers
; xmm0 and xmm1 are the float return registers
; http://www.nasm.us/links/unix64abi

global main,get_input,find_empty_location,read_nonl,write_record
extern printf,scanf,fopen,fread,fgets,stdin,strlen,fseek,fwrite,fclose

segment .bss

filename resb 80

segment .data

struc customer

c_id resd 1
c_name resb 65
c_address resb 65 
alignb 4
c_balance resd 1
c_rank resb 1 
alignb 4

endstruc

newcustomer istruc customer
            iend

segment .text

main:	                         ; main program
    push rbp                     
    mov rbp,rsp                  

    lea rdi,[newcustomer]        ; prompt user for filename and customer fields
    lea rsi,[filename]
    call get_input
    
    lea rdi,[filename]
    call find_empty_location
; rax has record number, rdx has file pointer    
    
    lea rdi,[newcustomer]        ; ptr to customer record first argument   
    mov rsi,rdx                  ; file pointer second
    mov rdx,rax                  ; record number third
    call write_record

    xor rax,rax                  ; return code 0
    leave                        ; fix stack
    ret                          ; return
    
; read_nonl reads a line of input trimming of the 
; trailing newline.
; Arguments:
; rdi - pointer to character buffer
; rsi - buffer size
; Register variables:
; rbx - saved pointer to customer structure
; r12 - saved pointer to file name buffer

read_nonl:	                 
    push rbp                     
    mov rbp,rsp                  
    push rbx
    push r12
    
    mov rbx,rdi                  ; save pointer to character buffer
    mov r12,rsi                  ; save buffer size
    
    mov rdx,[stdin]
    xor rax,rax                  ; no floating point args
    call fgets                   ; read a line
    
    xor rax,rax
    mov rdi,rbx                  ; point to character buffer
    call strlen                  ; get length of string
    dec rax                      ; strlen - 1
    mov byte [rbx+rax],0         ; put null over newline

    pop r12
    pop rbx
    xor rax,rax                  ; return code 0
    leave                        ; fix stack
    ret                          ; return


; get_input reads in the file name and
; each of the components of the new customer record.
; Arguments:
; rdi - pointer to customer structure
; rsi - pointer to file name buffer
; Register variables:
; rbx - saved pointer to customer structure
; r12 - saved pointer to file name buffer

segment .data

filenameprompt db "Enter file name: ",0
nameprompt db "Enter name: ",0
addressprompt db "Enter address: ",0
balanceprompt db "Enter balance: ",0
rankprompt db "Enter rank: ",0

balancescanfmt db "%d",0
rankscanfmt db "%ld",0

ranktemp dq 0

segment .text

get_input:	                 
    push rbp                     
    mov rbp,rsp                  
    push rbx
    push r12

    mov rbx,rdi                  ; save pointer to customer structure
    mov r12,rsi                  ; save pointer to file name buffer

; Print file name prompt
    lea rdi,[filenameprompt]     
    xor rax,rax                  ; no floating point args
    call printf                  ; print prompt
; Read filename using fgets
    mov rdi,r12                  ; file name buffer pointer
    mov rsi,80                   ; 80 byte buffer
    xor rax,rax                  ; no floating point args
    call read_nonl               ; read a line

; Prompt for and read in name
    lea rdi,[nameprompt]     
    xor rax,rax                  ; no floating point args
    call printf                  ; print prompt
    lea rdi,[rbx+c_name]         ; name buffer pointer
    mov rsi,65                   ; 65 byte buffer
    xor rax,rax                  ; no floating point args
    call read_nonl               ; read a line

; Prompt for and read in address
    lea rdi,[addressprompt]     
    xor rax,rax                  ; no floating point args
    call printf                  ; print prompt
    lea rdi,[rbx+c_address]      ; address buffer pointer
    mov rsi,65                   ; 65 byte buffer
    xor rax,rax                  ; no floating point args
    call read_nonl               ; read a line

; Prompt for and read in balance
    lea rdi,[balanceprompt]     
    xor rax,rax                  ; no floating point args
    call printf                  ; print prompt
    lea rdi,[balancescanfmt]   
    lea rsi,[rbx+c_balance]      ; balance buffer pointer
    xor rax,rax                  ; no floating point args
    call scanf                   ; read a line

; Prompt for and read in rank
    lea rdi,[rankprompt]     
    xor rax,rax                  ; no floating point args
    call printf                  ; print prompt
    lea rdi,[rankscanfmt]   
    lea rsi,[ranktemp]           ; rank is a byte so I'm reading in long
    xor rax,rax                  ; no floating point args
    call scanf                   ; read a line
    mov rax,[ranktemp]           ; rank
    mov [rbx+c_rank],al          ; load only the last byte

    pop r12
    pop rbx
    xor rax,rax                  ; return code 0
    leave                        ; fix stack
    ret                          ; return

; find_empty_location opens the file and reads each
; record looking for the first one with id=0. If it finds
; one it returns the record number of that record. Otherwise it
; returns the record number of the record that will be there after 
; a new record is appended
; Arguments:
; rdi - pointer to file name buffer
; Return registers
; rax - record number
; rdx - file pointer
; Register variables:
; r12 - saved pointer to file name buffer
; r13 - file pointer
; r14 - record number

segment .data

mode db "a+",0                  ; read-write append/create
tempcust istruc customer
         iend

segment .text

find_empty_location:	                 
    push rbp                     
    mov rbp,rsp                  
    push rbx
    push r12
    push r13
    push r14

    mov r12,rdi                  ; save pointer to file name buffer
    
    mov rdi,r12                  ; file name argument to fopen
    lea rsi,[mode]               ; mode
    call fopen
    mov r13,rax                  ; save file pointer
    
; seek to beginning of file    
    mov rdi,r13                  ; first argument to fseek, fp
    xor rsi,rsi                  ; seek to byte 0
    xor rdx,rdx                  ; whence is 0
    call fseek
    
    xor r14,r14                  ; start at record number 0
    
.readnext:
    lea rdi,[tempcust]           ; pointer to customer structure
    mov rsi,customer_size        ; size of structure
    mov rdx,1                    ; one element
    mov rcx,r13                  ; file pointer
    call fread
    cmp rax,1                    ; check if record was read
    jl .eof                      ; done reading file
    
    xor rax,rax
    mov eax,dword [tempcust+c_id] ; id of record that we read
    cmp rax,0                    ; see if current record has id 0
    je .eof                      ; yes, then exit
    inc r14                      ; next record
    jmp .readnext  
        
.eof:
    mov rax,r14                  ; return record number                 
    mov rdx,r13                  ; return file pointer
    pop r14                      
    pop r13                      
    pop r12                      
    pop rbx
    leave                        ; fix stack
    ret                          ; return

; write_record seeks to the location of the record number.
; it writes the record at that location and closes the file.
; before writing the record it updates the id field to be
; record number + 1
; Arguments:
; rdi - pointer to new customer record
; rsi - file pointer
; rdx - record number
; Register variables:
; rbx - saved pointer to customer structure
; r12 - file pointer
; r13 - record number
; r14 - new customer id

segment .data

outputfmt db `Id of new customer record is %ld\n`,0

segment .text

write_record:	                 
    push rbp                     
    mov rbp,rsp                  
    push rbx
    push r12
    push r13
    push r14

    mov rbx,rdi                  ; save pointer to new customer structure
    mov r12,rsi                  ; save file pointer
    mov r13,rdx                  ; save record number
; seek to record number    
    mov rdi,r12                  ;  first argument to fseek, fp
    mov rsi, r13
    imul rsi,customer_size       ; multiply record number by size of structure to get byte offset
    xor rdx,rdx                  ; whence is 0
    call fseek
; write record
    mov rax,r13
    inc rax
    mov dword [rbx+c_id],eax     ; save id in new customer structure
    mov r14,rax                  ; save in register
    mov rdi,rbx                  ; first arg to fwrite ptr to structure
    mov rsi,customer_size        ; second is size of structure
    mov rdx,1                    ; number of elements = 1 record
    mov rcx,r12                  ; file pointer
    call fwrite
; close file
    mov rdi,r12                  ; file pointer is argument to fclose
    call fclose
; print record id
    lea rdi,[outputfmt]          ; printf format
    mov rsi,r14                  ; customer id
    xor rax,rax                  ; no floating point args
    call printf                  ; print prompt

    pop r14                      
    pop r13                      
    pop r12                      
    pop rbx
    leave                        ; fix stack
    ret                          ; return
