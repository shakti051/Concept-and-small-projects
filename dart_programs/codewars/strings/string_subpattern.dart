//if a subpattern has been used, it will be present at least twice, meaning the subpattern has to be shorter than the original string;
/*"a"    --> false //no repeated shorter sub-pattern, just one character
"aaaa" --> true  //just one character repeated
"abcd" --> false //no repetitions
"babababababababa" --> true //repeated "ba"
"bbabbaaabbaaaabb" --> true //same as above, just shuffled*/

void main()
{
  bool result = subPattern("a");
  print(result);
}

bool subPattern(String str){
Map<String,int> freq = {};
for (var ch in str.split("")) {
  freq[ch]=(freq[ch] ??0)+1;
}
  int gcdValue=0;
  for (var num in freq.values) {
    gcdValue = gcd(gcdValue,num);
  }
  return gcdValue>=2;
}

int gcd(int a ,int b){
  while(b!=0){
    int temp = b;
    b=a%b;
    a=temp;
  }
  return a;
}