import java.util.HashMap;
import java.util.Map;

public class SubarraySumOptimize {

    public static void main(String[] args) {
        int[] arr = { -1, 1, 1};
        int k = 1;
        int subArrayLength = getLongestSubArray(arr,k);
        System.out.println("The max length is: "+subArrayLength);
    }

    public static int getLongestSubArray(int[] arr,int k){
        int maxLength = 0;
        int sum = 0;
        Map<Integer,Integer> prefixSum = new HashMap<>();
        int startIndex = -1,endIndex = -1;

        for(int i=0;i<arr.length;i++)
        {
            sum+=arr[i];
            if(sum==k)
            {
               // maxLength = Math.max(maxLength,i+1);
            if(maxLength < i+1){
                maxLength = i+1;
                startIndex = 0;
                endIndex = i;
            }
            }
            int rem = sum-k;
            if(prefixSum.containsKey(rem)){
              int len = i -  prefixSum.get(rem);
             // maxLength = Math.max(maxLength,len);
             if(maxLength < len){
                 maxLength = len;
                 startIndex = prefixSum.get(rem)+1;
                 endIndex = i;
             }
            }
            prefixSum.putIfAbsent(sum,i);
        }
        for (int i= startIndex;i<=endIndex;i++)
            System.out.println(arr[i]);
        return maxLength;
    }
}
