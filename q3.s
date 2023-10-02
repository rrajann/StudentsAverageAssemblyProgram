.pos 0x100
                ld $s, r0           # r0 = &s
                ld (r0), r0         # r0 = s                            **
                ld $0, r7           # r7 = j = 0 (index for s[j])       **
                ld $n, r6           # r6 = &n
                ld (r6), r6         # r6 = n                            **
stu_loop:       mov r7, r5          # r5 = j'
                not r5             
                inc r5              # r3 = -j'
                add r6, r5          # r4 = n - j                        
                beq r5, stu_end     # if (n == j), goto stu_end
                ## set up s[j]:
                mov r7, r5
                mov r5, r1          # r1 = j'
                shl $3, r1          # r1 = j * 8
                shl $4, r5          # r5 = j * 16
                add r1, r5          # r5 = j*8 + j*16 = j * 24 =        
                add r0, r5          # r5 = &s[j]                        **
                ld $0, r1           # r1 = i = 0                        **
                ld $0, r2           # r2 = sum = 0                      **
                ld $4, r4           #                                   **           
grade_loop:     mov r1, r3          # r3 = i'
                not r3
                inc r3              # r3 = -i'
                add r4, r3          # r4 = 5 - i
                beq r3, grade_end   # if (4 == i), goto grade_end   
                ld $4, r3           # r3 = 4
                add r5, r3          # r3 = &grade[i]
                ld (r3, r1, 4), r3  # r3 = grade[i]
                add r3, r2          # sum += grade[i]
                inc r1              # i++
                br grade_loop       # goto grade_loop
grade_end:      shr $2, r2          # r2 = average = sum / 4
                st r2, 20(r5)       # s[j].average = average
                inc r7              # j++
                br stu_loop
stu_end:        j bubble_sort


swap:           mov r0, r1          # r0 is the argument (index), moved to r1
                shl $3, r0          # index * 8
                shl $4, r1          # index * 16
                add r0, r1          # r1 = index * 24
                mov r1, r3
                ld $24, r5
                add r5, r3          # r3 = index * 24 + 24   
                ld $s, r5           # r5 = &s
                ld (r5), r5         # r5 = s
                add r5, r1          # r1 = &s[index]                    **
                add r5, r3          # r3 = &s[index + 1]                **
                ld 20(r1), r4       # r4 = s[index].average
                ld 20(r3), r5       # r5 = s[index+1].average
                not r5
                inc r5
                add r5, r4          # r4 = s[index].average - s[index+1].average
                bgt r4, cont        # if index + 1 > index
                j back
cont:           ld $0, r0           # i' = 0                            **
                ld $6, r5           # r5 = 6                            **
swap_loop:      mov r0, r4          # r4 = i'
                not r4
                inc r4
                add r5, r4          # r4 = 6 - i
                beq r4, s_loop_end  # if (i == 6)
                ld (r1, r0, 4), r4  # r4 = s[index].element (depends on i')
                ld (r3, r0, 4), r6  # r4 = s[index + 1].element (depends on i')
                st r4, (r3, r0, 4)  # s[index + 1].element = s[index].element
                st r6, (r1, r0, 4)  # s[index].element = s[index + 1].element
                inc r0
                br swap_loop
s_loop_end:     j back

# void sort (int* a, int n) {
#   for (int i=n-1; i>0; i--)
#     for (int j=1; j<=i; j++)
#       if (a[j-1] > a[j]) {
#         int t = a[j];
#         a[j] = a[j-1];
#         a[j-1] = t;
#       }
# }

bubble_sort:    ld $n, r7
                ld (r7), r7         # r7 = n
                dec r7              # r7 = n-1 = i                      ** r7
bubble_loop:    beq r7, bubble_end  # if i = 0, goto bubble_end
                ld $1, r2           # r2 = j = 1                        ** r2
inner_loop:     mov r2, r3          # r3 = j'
                not r3
                inc r3              # r3 = -j'
                add r7, r3          # r3 = i - j'
                bgt r3, nd          # j < i
                beq r3, nd          # j == i
                dec r7              # i-- (inner_loop end)
                br bubble_loop      # j > i
nd:             mov r2, r0          # r0 = j'
                dec r0              # j-- (to test if j-1>j, bc the swap parameter looks forward)
                gpc $6, r6          # r6 = pc
                j swap
back:           inc r2
                br inner_loop
bubble_end:     j end

end:            ld $s, r0           
                ld (r0), r0         # r0 = s
                ld $n, r1           
                ld (r1), r1         # r1 = n
                inc r1              # n++
                shr $1, r1          # r1 = r1 / 2
                dec r1
                mov r1, r3          # r3 = r1
                shl $3, r1
                shl $4, r3
                add r1, r3
                add r0, r3
                ld (r3), r5
                ld $m, r7
                st r5, (r7)
                halt




.pos 0x2000
n:              .long 3       # 3 students 
m:              .long 0       # put the answer here
s:              .long base    # address of the array
base:           .long 1234    # student ID
                .long 80      # grade 0
                .long 60      # grade 1
                .long 78      # grade 2
                .long 90      # grade 3
                .long 0       # average (ex=77)
                .long 5678    # sid
                .long 0
                .long 20
                .long 40
                .long 80
                .long 0       # average (ex=35)
                .long 4321    # sid
                .long 100
                .long 83
                .long 90
                .long 3
                .long 0       # average (ex=69)