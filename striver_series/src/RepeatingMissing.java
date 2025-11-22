
public class RepeatingMissing {

    public static void main(String[] args) {
        int[] arr = {3, 1, 2, 5, 4, 6, 7, 5};
        int[] ans = findMissingRepeatingNumbers(arr);
        System.out.println("The repeating and missing numbers are: {"
                + ans[0] + ", " + ans[1] + "}");
    }

    private static int[] findMissingRepeatingNumbers(int [] arr){
        int repeating = -1;
        int missing = -1;
        for(int i=1;i<=arr.length;i++){
            int count = 0;
            for(int num:arr){
                if(num==i)count++;
            }
            if(count==2)repeating = i;
            if(count==0)missing = i;
        }
        return new int[]{repeating,missing};
    }

}
