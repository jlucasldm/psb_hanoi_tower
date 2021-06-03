SECTION .data
n_discos db 3

SECTION .text
global  _start
 
; Pseudocódigo da resolução da torre de hanói por recursão

; X - número de discos
; S - coluna de sáida
; D - coluna de destino
; T - coluna temporária

;   hanoi(X, S, D, T):
;		IF X == 1, THEN:
;    		print move X from S to D
;    		return
;		ELSE:
;    		hanoi(X - 1, S, T, D)   
;    		print move X from S to D 
;    		hanoi(X - 1, T, D, S) 
;    		return



_start:  
    xor al, al ; AL - armazena coluna de saída  (S)
    xor ah, ah ; AH - armazena coluna de destino (D)
    xor bl, bl ; BL - armazena coluna temporária (T)
    xor bh, bh ; BH - armazena número de discos (X)

    ; Inicializando os registradores com os valores iniciais
    ; Colunas: S = 1, T = 2, D = 3
    mov bh, [n_discos]
    mov al, 1 ; S
    mov bl, 2 ; T
    mov ah, 3 ; D
    

    ; Executando a função recursiva
    call _hanoi    
    call _quit
    


_hanoi: ; hanoi(X, S, D, T) = hanoi(bh, al, ah, bl)
    cmp bh, 1 ; Compara o número de discos para verificar se há apenas um disco.
    je _if

    ;----------------------hanoi(X - 1, S, T, D) -----------------
    
    ; Salvando contexto AL, AH, BL e BH
    push ax
    push bx
    
    ; Preparando parâmetros hanoi(X - 1, S, T, D) 
    dec bh      ; bh = X - 1
    xchg ah, bl ; swap T e D
    
    call _hanoi ; hanoi(X - 1, S, T, D) 
    
    ; Retomando contexto AL, AH, BL e BH
    pop bx
    pop ax

    ;--------------------print move X from S to D ----------------
    call _print_mover ; Printa o movimento do disco
    
    ;----------------------hanoi(X - 1, T, D, S) -----------------
    ; Salvando contexto AL, AH, BL e BH
    push ax
    push bx
    
    ; Preparando parâmetros hanoi(X - 1, T, D, S)
    dec bh      ; bh = X - 1
    xchg al, bl ; swap T e S
    
    call _hanoi ; hanoi(X - 1, T, D, S) 
    
    ; Retomando contexto AL, AH, BL e BH
    pop bx
    pop ax
    ;--------------------------------------------------------------    

    jmp _ret 
_if: ; Se número de discos é igual a 1.
    call _print_mover
_ret:
    ret


_print_inicio:
    push string_inicio  ;inserindo à pilha a string a ser impressa
    extern printf       ;chamada da função em C, já que windows não permite comando int
    call printf         ;itera sobre o topo da pilha e imprime a string
    pop edx             ;remove a string da pilha
    ret

string_inicio:
    db "Torre de hanoi com três discos", 0xa, 0 ; 0xa = newline, 0 = end of a C string.

_print_mover:
    ret

_print_final:
    push string_final  ;inserindo à pilha a string a ser impressa
    extern printf       ;chamada da função em C, já que windows não permite comando int
    call printf         ;itera sobre o topo da pilha e imprime a string
    pop edx             ;remove a string da pilha
    ret

string_final:
    db "Procedimento solucionado", 0xa, 0 ; 0xa = newline, 0 = end of a C string.


_quit:
    mov       rax, 60                
    xor       rdi, rdi                
    syscall 