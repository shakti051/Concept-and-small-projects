import java.util.Arrays;

public class RearrangePosNegElement {

    public static void main(String[] args) {
        int[] arr = {3,1,-2,-5,2,-4};
        int posIndex = 0;
        int negIndex = 1;
        int[] temp = new int[arr.length];
        for(int num : arr){
            if(num>0){
                temp[posIndex] = num;
                posIndex+=2;
            }else {
                temp[negIndex] = num;
                negIndex+=2;
            }
        }
        System.out.println(Arrays.toString(temp));
    }
}
