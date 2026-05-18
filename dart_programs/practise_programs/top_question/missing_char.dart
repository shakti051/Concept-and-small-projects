

void main() {
List<String> arr = ['P','Q','R','S','T','V'];

 for (var i = 0; i < arr.length-1; i++) {
   int current = arr[i].codeUnitAt(0);
   int next = arr[i+1].codeUnitAt(0);
   if(next-current>1){
    
    print(String.fromCharCode(current+1));
    return;
   }
 }
}
