

public class MissingElement {

    public static void main(String[] args) {
        int N = 5;
        int[] arr = {1, 2, 4, 5};
        int sum =(N*(N+1))/2;
        int arrSum = 0;
         for(int num : arr)
             arrSum+=num;
        int missingNumber = sum-arrSum;
        System.out.println("The missing number is: "+missingNumber);
    }
}
