import java.util.Arrays;

public class MoveZeros {

    public static void main(String[] args) {
        int[] arr = {1, 0, 2, 3, 2, 0, 0, 4, 5, 1};
        int n = arr.length;

        int j = 0; // index to place the next non-zero element

        for(int i=0;i<arr.length;i++){
            if(arr[i]!=0){
                int temp = arr[i];
                arr[i]=arr[j];
                arr[j]=temp;
                j++;
            }
        }
        System.out.println("The required array is: "+ Arrays.toString(arr));
    }
}
