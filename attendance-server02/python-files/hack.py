A_ =input()
B=input()

A= list(B.split(" "))

print(A)


new_A =""

for i in A:
    stripped=str(i)[-1]
    new_A+=stripped

if int(new_A)%10==0:
    print("Yes")
else:
    print("No")