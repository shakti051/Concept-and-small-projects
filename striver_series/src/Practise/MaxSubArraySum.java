package Practise;

public class MaxSubArraySum {

    public static void main(String[] args) {
       int[] arr = {-2,1,-3,4,-1,2,1,-5,4};
       int sum = 0;
       int start = -1;
       int startIndex = -1;
       int endIndex = -1;
       int maxSum = Integer.MIN_VALUE;
       for(int i = 0;i<arr.length;i++){
           if(sum==0)start=i;
           sum+=arr[i];
           if(sum>maxSum){
               maxSum = sum;
               startIndex = start;
               endIndex = i;
           }
           if(sum<0)
               sum=0;
       }
        System.out.println(maxSum);
        System.out.println();
        for(int i = startIndex;i<=endIndex;i++){
            System.out.print(arr[i]+" ");
        }
    }
}
