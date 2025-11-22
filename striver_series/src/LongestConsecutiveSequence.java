import java.util.HashSet;
import java.util.Set;

public class LongestConsecutiveSequence {

    public static void main(String[] args) {
        int[] arr = {100, 200, 1, 2, 3, 4};
        int ans = longestSuccessiveElements(arr);
        System.out.println("The longest sequence "+ans);
    }

    private static int longestSuccessiveElements(int [] arr){
        int longest = 0;
        Set<Integer> integerSet = new HashSet<>();
        for(int num : arr) integerSet.add(num);
        for (int num : integerSet){
            if(!integerSet.contains(num-1)){
                int x = num;
                int count = 1;
                while (integerSet.contains(x+1)){
                    x++;
                    count++;
                }
                longest = Math.max(count,longest);
            }
        }
        return longest;
    }
}
