

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

  //  List<String> arr = ['P', 'Q', 'R', 'S', 'T', 'V'];
  // int xor = 0;
  // String max = arr.reduce((a, b) => a.codeUnitAt(0) > b.codeUnitAt(0) ? a : b);
  // String min = arr.reduce((a, b) => a.codeUnitAt(0) < b.codeUnitAt(0) ? a : b);;

  // for (var i = min.codeUnitAt(0); i <= max.codeUnitAt(0); i++) {
  //   xor ^= i;
  // }

  // for (var value in arr) {
  //   xor ^= value.codeUnitAt(0);
  // }
  // print(String.fromCharCode(xor));

}
