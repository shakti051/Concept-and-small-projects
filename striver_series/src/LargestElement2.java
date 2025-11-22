
public class LargestElement2 {

    public static void main(String[] args) {
        int[] arr = {2, 5, 1, 3, 0};
        int max = arr[0];
        for(int num :arr)
        {
            if(num>max) max = num;
        }
        System.out.println("The max number is "+max);
    }
}


