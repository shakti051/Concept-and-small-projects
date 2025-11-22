import java.util.*;

public class CountSubArrayGivenSumOptimize {

    public static void main(String[] args) {
        int[] arr = {3, 1, 2, 4};
        int k = 6;
        int cnt = findAllSubarraysWithGivenSum(arr, k);
        System.out.println("The number of subarrays is: " + cnt);
    }

    private static int findAllSubarraysWithGivenSum(int[] arr, int k){
        int count = 0;
        Map<Integer,Integer> prefixSumCount = new HashMap<>();
        int sum = 0;
        prefixSumCount.put(0,1);
        for(int num :arr){
            sum+=num;
            int rem = sum -k;
            if(prefixSumCount.containsKey(rem)){
                count+= prefixSumCount.get(rem);
            }
            prefixSumCount.put(sum, prefixSumCount.getOrDefault(sum,0)+1);
        }
        return count;
    }
}
