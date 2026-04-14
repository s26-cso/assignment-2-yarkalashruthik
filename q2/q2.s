.section .rodata
fmt_int:   .string "%d"
fmt_space: .string " " 
fmt_nl:    .string "\n"
.globl main
.text
main:
li t0, 1 t0=1 to check if arguement is atleast 1
beq a0, t0, end #exit if only 1 arguement ie ./a.out 
addi sp,sp,-32 
sd s0,0(sp)
sd s1,8(sp)
sd s2,16(sp)
sd ra,24(sp)
addi t5,a0,-1 #t5=a0-1=n 
addi t0,x0,12 #t0=12
mul t5,t0,t5 #t5=12*n
li t0,16 #t0=16
rem t0,t5,t0 #12n%16
addi t5,t5,16 #12n+16=t5
sub t5,t5,t0 #t5=12n+16-12n%16,to make sure decremented value of sp is divisble by 16 
sub sp,sp,t5#allocate memory on stack, 4*n bytes ie n elements of arr lly n stack, n ans ,
addi t0,x0,1 #t0=1 1stloop counter
addi a3,sp,0 #a3=sp 
add t1,x0,a0 #t1=n
loop1: 
beq t0,t1,loopend #jump if t0=n
addi t4,x0,8#t4=8
mul t4,t4,t0 #t4=8*t0 
add t4,t4,a1 #t2=t4+a1 ie address+offset this gives address of adress of string 
ld a0,0(t4) #loading adress of string into a0 
addi sp,sp,-32 #for saving values(Can do with save registers too)
sd a3,0(sp)
sd t1,8(sp)
sd t0,16(sp)
sd a1,24(sp) 
jal ra,atoi
ld a3,0(sp)
ld t1,8(sp)
ld t0,16(sp)
ld a1,24(sp)
addi sp,sp,32
sw a0,0(a3)
addi a3,a3,4
addi t0,t0,1
beq x0,x0,loop1
loopend:
nxtgreater:
addi t1,t1,-1 #t1=n now as there were n+1 arguements
addi t4,x0,4#t4=4
addi t6,t1,-1 #t6=n-1
add a3,sp,x0 
mul t4,t4,t6 #4*(n-1)
add a3,a3,t4 # a3 points to last element in array now
addi t2,a3,0 #t2=mystacktop
addi t3,a3,0 #t3=stackend
while:
blt a3,sp,whileend
lw t5,0(a3) #curr elem of arr
elim:
bge t3,t2,elimend
lw t4,0(t2) #t4=index at stack top
li a6,4 #a6=4 
mul a6,a6,t4 #a6=t4*4
add a6,sp,a6 #a6=t4*4+sp which gives array element address
lw a6,0(a6) #a6=arr elem
bgt a6,t5,elimend #stacktop>curr
addi t2,t2,-4 #pop
beq x0,x0,elim
elimend:
beq t3,t2,stackisempty
addi a5,x0,8
mul a5,a5,t1 #a5=8n
add a5,a3,a5 #a3+8*n 
sw t4,0(a5) #store answer index on stack 
stackemptyret:
addi t2,t2,4 #update my top of stack to add element
sub a6,a3,sp #gives index of arr elem i.e index=a3-sp but we need to divide by 4(bytes included in this)
srai a6,a6,2 # shift right arithmetic by 2 bits,ie divide by 4
sw a6,0(t2) #adding arr element to stack
addi a3,a3,-4 #update arr pointer
beq x0,x0,while
whileend:
addi a5,x0,8 #a5=8
mul a5,a5,t1 #a5=8n
add s2,sp,a5 #s2=8n+sp
addi s0,x0,0 #s0=0
add s1,x0,t1 #s1=t1=n
print:
beq s1,s0,end
la a0, fmt_int
lw a1, 0(s2)
jal ra,printf
addi s2,s2,4
addi s0,s0,1
beq s0, s1, skip_space #to skip trailing space at the last print of value
la a0, fmt_space
jal ra, printf
skip_space:
beq x0,x0,print
stackisempty:
addi a4,x0,-1 #a4=-1
addi a5,x0,8 #a5=8
mul a5,a5,t1
add a5,a3,a5 #a3+8*n 
sw a4,0(a5) #stored -1 answer
beq x0,x0,stackemptyret
end:
la a0, fmt_nl
jal ra, printf
addi a6,x0,12 #a6=12
mul a5,a6,s1 #a5=12*n
mv t5,a5 #t5=a5
li t0,16 #t0=16
rem t0,t5,t0 #12n%16
addi t5,t5,16 #12n+16=t5
sub t5,t5,t0 #t5=12n+16-12n%16,to make sure decremented value of sp is divisble by 16 
add sp,sp,t5 #sp=sp+12*n+16-12n%16 (restored memory allocated for stack,arr,answer)
ld s0,0(sp)
ld s1,8(sp)
ld s2,16(sp)
ld ra,24(sp)
addi sp,sp,32 
ret 




