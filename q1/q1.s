.globl make_node
.text
make_node:
addi sp,sp,-16 #storing value of a0
sd a0,0(sp)
sd x1,8(sp)
li a0, 24             
jal ra, malloc
ld t0,0(sp)
ld x1,8(sp)
addi sp,sp,16
sw t0,0(a0)
sd x0,8(a0)  #pointer=NULL
sd x0,16(a0) #pointer-NULL
ret
.globl insert
.text
insert:
#a0 contains root,a1 contains val,x1 return address
add a2,x0,a0 #a2=temp
add a3,x0,x0 #a3=parent=NULL
add a4,x0,x0 #a4=16=right of parent else a4=8 left
loopinsert:
beq a2,x0,loopinsertend #while temp!=NULL
lw t0,0(a2) #temp->val
add a3,a2,x0 #parent=temp
bgt a1,t0,grterthan
ld a2,8(a2) #temp=temp->left
addi a4,x0,8 #a4=8;
beq x0,x0,loopinsert
grterthan:
ld a2,16(a2) #temp=temp->right
addi a4,x0,16 #a4=16
beq x0,x0,loopinsert
loopinsertend:
#lets call create node since a0 contains root we'll move it to save with parent and left,right
addi sp,sp,-32
sd s0,0(sp)
sd s1,8(sp)
sd s2,16(sp)
sd x1,24(sp)
add s0,x0,a0
add s1,x0,a3
add s2,x0,a4
add a0,x0,a1 #a0=val
jal ra,make_node  
beq x0,s2,rootisnull
add t5,s1,s2
sd a0,0(t5) #parent->left/right=create_node(val)
add a0,x0,s0 #putting root in a0 in root
ld s0,0(sp)
ld s1,8(sp)
ld s2,16(sp)
ld x1,24(sp)
addi sp,sp,32
ret 
rootisnull:
#a0 has pointer of new node which is root now
ld s0,0(sp)
ld s1,8(sp)
ld s2,16(sp)
ld x1,24(sp)
addi sp,sp,32
ret 
.globl get
.text
get:
#a0 contains root,a1 contains val,x1 return address
add a2,x0,a0 #a2=temp
loopinsert2:
beq a2,x0,loopinsertend2 #while temp!=NULL
lw t0,0(a2) #temp->val
bgt a1,t0,grterthan2
beq a1,t0,equalend
ld a2,8(a2) #temp=temp->left
beq x0,x0,loopinsert2
grterthan2:
ld a2,16(a2) #temp=temp->right
beq x0,x0,loopinsert2
loopinsertend2:
add a0,x0,x0
ret 
equalend:
add a0,a2,x0 #put temp in a0 and return 
ret 
.globl getAtMost
.text
getAtMost:
#a0 contains root,a1 contains val,x1 return address
add a2,x0,a0 #a2=temp
add a3,x0,x0 #a3=parent
addi t3,x0,-1 #t3=floor 
loopinsert3:
beq a2,x0,loopinsertend3 #while temp!=NULL
add a3,x0,a2 #parent=temp 
lw t0,0(a2) #temp->val
ble t0,a1,ceilupdate
ceilupdated:
bgt a1,t0,grterthan3 
beq a1,t0,loopinsertend3
ld a2,8(a2) #temp=temp->left
beq x0,x0,loopinsert3
grterthan3:
ld a2,16(a2) #temp=temp->right
beq x0,x0,loopinsert3
loopinsertend3:
bgt t3,a1,novalueexists
addi a0,t3,0 #a0=t3
ret  
novalueexists:
addi a0,x0,-1 
ret 
ceilupdate:
add t3,x0,t0 #ceil=temp->val
beq x0,x0,ceilupdated

