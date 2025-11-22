

public class CountSubArrayGivenSum {

    public static void main(String[] args) {
        int[] arr = {3, 1, 2, 4};
        int k = 6;
        int cnt = findAllSubarraysWithGivenSum(arr, k);
        System.out.println("The number of subarrays is: " + cnt);
    }

    private static int findAllSubarraysWithGivenSum(int[] arr,int k){
        int count = 0;
        for(int i =0 ;i<arr.length;i++){
            int sum = 0;
            for (int j = i;j<arr.length;j++){
                    sum+= arr[j];
                    if(sum==j)
                        count++;
            }
        }
        return  count;
    }
}

