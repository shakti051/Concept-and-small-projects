package Interview;

import java.util.*;

public class XceloreInterview {
  //Count frequencies of alphate in a string
  public static void main(String[] args) {
      String str = "Hello Wordddd";
      str = str.replaceAll(" ","");
      char[] charArray = str.toCharArray();
      HashMap<Character,Integer> map = new HashMap<>();
      for (char i: charArray)
      {
          map.put(i,map.getOrDefault(i,0)+1);

      }
      //System.out.println(map);
      int maxFreq= 0;
      for(int freq :  map.values()){
          if(freq>maxFreq)
              maxFreq = freq;
      }
      System.out.println(maxFreq);
      for(Map.Entry<Character,Integer> entry: map.entrySet() ){
          System.out.print(entry.getKey()+":"+ entry.getValue()+"," );
      }
  }
}
