.section .rodata
filename: .string "input.txt"
mode_r:   .string "r"
fmt_yes:  .string "Yes\n"
fmt_no:   .string "No\n"
.globl main
.text
main:
    addi sp,sp,-48 #for saving save register values before to use them 
    sd ra,40(sp) 
    sd s0,32(sp) #s
    sd s1,24(sp)
    sd s2,16(sp)
    sd s3,8(sp)
    la a0,filename#load adress oof filename string 
    la a1,mode_r #load address of string r to read 
    jal ra,fopen #calls function fopen("input.txt","r") read mode,a0,a1 are function arguments
    mv s0,a0 #a0 contains file ptr which is moved to s0 
    mv a0,s0 #a0=fileptr
    li a1,0 # a1=0
    li a2,2 #a2=2(seek from end)
    jal ra,fseek #goes to end in file
    mv a0,s0 #a0=fileptr 
    jal ra,ftell #ftell gives the cursor pter in file to a0
    addi s2,a0,-1 #-1 from a0 to get last character
    li s1,0 #s1=0
    bltz s2,exit_yes #if right pter/index is -ve employs file empty and exit 
    mv a0,s0#a0=s0
    mv a1,s2#a1=s2 
    li a2,0 #a2=0 
    jal ra,fseek #call fseek 
    mv a0,s0 #a0=s0 
    jal ra,fgetc#get the last character 
    li t0,10 #load 10 
    bne a0,t0,loop #check if last character is \n
    addi s2,s2,-1 #if last character is \n then subtract the pointer 
loop:
    bge s1,s2,exit_yes #if left pointer>=right pointer end loop 
    mv a0,s0 #a0=s0
    mv a1,s1 #a1=s1 
    li a2,0 #a2=0 
    jal ra, fseek#cursor moves to left index 
    mv a0,s0#a0=s0
    jal ra,fgetc #get character from file 
    mv s3,a0#s3=a0 
    mv a0,s0#a0=s0
    mv a1,s2#a1=s2
    li a2,0#a2=0
    jal ra,fseek#curosor moves to right index/ptr
    mv a0,s0#a0=s0
    jal ra,fgetc#get character from file 
    bne s3,a0,exit_no#if both characters not same then exit 
    addi s1,s1,1 #update left index
    addi s2,s2,-1#update right index 
    beq x0,x0,loop #jump unconditional
exit_yes:
    la a0,fmt_yes #load adress of yes string 
    beq x0,x0,print #jump to print 
exit_no: 
    la a0,fmt_no #load address of no string 
print:
    jal ra,printf #call printf 
    mv a0,s0 #a0=s0 
    jal ra,fclose #close file 
    li a0,0#a0=0 
    ld ra,40(sp) 
    ld s0,32(sp)
    ld s1,24(sp)
    ld s2,16(sp)
    ld s3,8(sp) #reloading values to return to os
    addi sp,sp,48#update stack pointer
    ret