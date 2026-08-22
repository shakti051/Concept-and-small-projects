
void main() {
List<int> arr = [56,57,58,60];
int xor = 0;
int max = arr.reduce((a,b)=> a> b ?a:b);
print(max);
int min = arr.reduce((a,b)=> a< b ?a:b);
print(min);
 for(int i = arr.first ; i<=arr.last;i++){
        xor^=i;
 }   

 for (var num in arr) {
    xor^=num;
 }
print(xor);
}
