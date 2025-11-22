
public class MaxSubArraySum {

    public static void main(String[] args) {
        int[] arr = { -2, 1, -3, 4, -1, 2, 1, -5, 4};
        int n = arr.length;
        long maxSum = maxSubarraySum(arr, n);
        System.out.println("This is maxsum: "+maxSum);
    }

    private static long maxSubarraySum(int[] arr,int n){
        long maxi = Long.MIN_VALUE;
        long sum = 0;
        int start = 0;
        int ansStart = -1,ansEnd = -1;

        for (int i = 0;i<arr.length;i++){
            if (sum==0)start = i;
            sum+=arr[i];
            if(sum<0)
                sum = 0;
            if(sum>maxi){
                maxi = sum;
                ansStart = start;
                ansEnd = i;
            }
        }
        for (int i = ansStart;i<=ansEnd;i++)
            System.out.println(arr[i]);
        return maxi;
    }
}