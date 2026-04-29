
void main() {
int num = 78;
int reverse =0;
while(num!=0){
    int lastDigit = num%10;
    reverse = reverse*10+lastDigit;
    num ~/=10;
}
print(reverse);
}
