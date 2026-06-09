DEFAULT REL

section .data
    EnterNumMSG db 'Enter a number: ', 10
    EnterNumMSG_len equ $ - EnterNumMSG

    ConvertErrorMSG db 'Invalid input. Please enter a valid number.', 10
    ConvertErrorMSG_len equ $ - ConvertErrorMSG

    OutputMSG_1 db 'The sum from 1 to ',0
    OutputMSG_1_len equ $ - OutputMSG_1
    OutputMSG_2 db ' is: ', 0
    OutputMSG_2_len equ $ - OutputMSG_2

section .bss
    number_input resb 4
    output_str resb 8
    temp_reg resb 4

    input_number_len resb 1
    output_sum_len resb 1
section .text
    global _start

_start:
    ; Print message
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, EnterNumMSG        ; message to write
    mov edx, EnterNumMSG_len    ; message length
    int 0x80
    ; Input number
    mov eax, 3          ; sys_read
    mov ebx, 0          ; stdin
    mov ecx, number_input ; buffer to store input
    mov edx, 5          ; number of bytes to read
    int 0x80


    dec eax ; eax now holds the number of bytes read

    mov [input_number_len], al ; Store the length of the input for later use

    cmp eax, 1 ; Check if the input is valid (at least 1 character)
    jb exit_convert ; If not, exit the conversion process

    mov ecx, eax ; Store the number of bytes read in ecx for the loop counter
    xor ebx, ebx ; Clear ebx to use it for the index
   
    mov esi, number_input ; Point esi to the input buffer
    convert_string_loop:
        xor eax, eax ; Clear eax to use it for the conversion result

        mov al, byte [esi] ; Load the current character into al

        ; Check if the character is a valid digit (between '0' and '9')
        cmp  al , '0'          ; Check for null terminator
        jb  exit_convert          ; If it's less than '0', exit the loop
        cmp  al , '9'          ; Check if it's greater than '9'
        ja  exit_convert          ; If it's greater than '9', exit the loop

        ; Convert the character to its integer value and accumulate the result
        sub  al , '0'          ; Convert ASCII to integer
        imul ebx, 10      ; Multiply the current result by 10
        add ebx , eax          ; Add the new digit
        
        ; Move to the next character
        inc esi


        dec ecx              ; Decrement the loop counter
        jnz convert_string_loop          ; If not, continue the loop



    xor eax, eax        ; Initialize sum to 0
    mov ecx, ebx        ; Move the input number into ecx for the loop counter

    ; Loop to calculate the sum from 1 to the input number
    sum_loop:
        add eax, ecx

        cmp ecx, 1
        dec ecx
        jnz sum_loop

    ; Calculate the number of digits in the sum
    mov [temp_reg], eax    ; Store the final quotient (which should be 0) in a temporary register
    mov ebx, 10          ; Divide by 10 to get the next digit
    xor ecx, ecx
    count_digits_loop:
        xor edx, edx         ; Clear edx for division
        div ebx              ; Divide eax by 10 to get the next digit
        
        inc ecx              ; increase the digit count

        cmp eax, 0
        jnz count_digits_loop
    
    ; Convert the sum to a string for output
    mov eax, [temp_reg]    ; Load the sum back into eax for conversion
    mov ebx, 10 ; Divide by 10 to get each digit
    mov edi, output_str + 7

    convert_sum_loop:
        xor edx, edx ; Clear edx for division
        div ebx ; Divide eax by 10, quotient in eax and remainder in edx

        add dl, '0' ; Convert the remainder to ASCII  
        mov [edi], dl ; Store the ASCII character in the output buffer
        dec edi ; Move to the next position in the output buffer

        inc [output_sum_len] ; Increment the output string length
        dec ecx ; Decrement the digit counter
        jnz convert_sum_loop ; If there are more digits to process, continue the loop


    ; Print the result
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, OutputMSG_1        ; message to write
    mov edx, OutputMSG_1_len    ; message length
    int 0x80
    
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, number_input         ; message to write
    movzx edx, byte [input_number_len]          ; message length
    int 0x80

    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, OutputMSG_2        ; message to write
    mov edx, OutputMSG_2_len    ; message length
    int 0x80

    mov ecx, output_str
    movzx edx, byte [output_sum_len] ; Load the length of the output string
    add ecx, 8          ; Point to the start of the output string (the most significant digit)
    sub ecx, edx ; Move back to the start of the number string
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    movzx edx, byte [output_sum_len] ; Load the length of the output string
    int 0x80

    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, 10          ; message to write (newline)
    mov edx, 1          ; message length
    int 0x80



_exit:
    mov eax, 1
    mov ebx, 0
    int 0x80

exit_convert:
     ; If the input is not a valid number, we can exit or handle it as needed
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, ConvertErrorMSG        ; message to write
    mov edx, ConvertErrorMSG_len    ; message length
    int 0x80