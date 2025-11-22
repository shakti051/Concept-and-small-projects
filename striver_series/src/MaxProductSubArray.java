
public class MaxProductSubArray {
    public static void main(String[] args) {
        int[] arr = {2, 3, -2, 4};
        int max = maxProduct(arr);
        System.out.println("The max sub array product: "+max);
    }

    public static int maxProduct(int[] arr) {
        int result = Integer.MIN_VALUE;
        int prefix = 1;
        int suffix = 1;
        int n = arr.length;
        for(int i=0;i<arr.length;i++){
            if(prefix==0)prefix = 1;
            if(suffix==0)suffix=1;
            prefix *=arr[i];
            suffix *=arr[n-i-1];
            result = Math.max(result,Math.max(prefix,suffix));
        }
        return  result;
    }
}
