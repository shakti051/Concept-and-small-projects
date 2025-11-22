package Practise;
import java.util.HashMap;

public class LongestSubarrayGivenSum {

    public static void main(String[] args) {
        int[] arr = { -1, 1, 1};
        int k = 1;
        int maxLength = 0;
        int startIndex = -1;
        int endIndex = -1;

        HashMap<Integer,Integer> map = new HashMap<>();
        int sum= 0;
        for(int i =0;i<arr.length;i++){

            sum+=arr[i];
            if(sum==k){
                //maxLength = Math.max(maxLength,i+1);
              if(i+1>maxLength){
                  maxLength = i+1;
               startIndex = 0;
               endIndex = i;
              }
            }


            int reminder = sum-k;
            if(map.containsKey(reminder)){
                int len = i - map.get(reminder);
               // maxLength = Math.max(maxLength,len);
            if(len>maxLength){
                maxLength = len;
                startIndex = map.get(reminder)+1;
                endIndex = i;
            }
            }else{
                map.put(sum,i);
            }
        }
        System.out.println(maxLength);
        System.out.println();
        for(int i = startIndex;i<=endIndex;i++){
            System.out.print(arr[i]+"  ");
        }
    }
}
