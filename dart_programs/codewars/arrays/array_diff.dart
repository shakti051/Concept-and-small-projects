// If a = [1, 2] and b = [1], the result should be [2].

// If a = [1, 2, 2, 2, 3] and b = [2], the result should be [1, 3].

// If a = [1, 2] and b = [1], the result should be [2].

// If a = [1, 2, 2, 2, 3] and b = [2], the result should be [1, 3].

void main(){
 List<int> a = [1, 2, 2, 2, 3]; 
 List<int> b = [2];
 Set<int> bSet = b.toSet();
 List<int> result = [];
  for (var num in a) {
    if(!bSet.contains(num)){
      result.add(num);
    }
  }
  print(result);
}

// Time = O(m + n)
// Space = O(m + n)
// if don't take set O(m * n) 