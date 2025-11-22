import java.util.HashMap;

public class PairGivenSum {

    public static void main(String[] args) {
        int n = 5;
        int[] arr = {2, 6, 5, 8, 11};
        int target = 14;
        int[] ans = twoSum(n, arr, target);
        System.out.println("This is the answer for variant 2: [" + ans[0] + ", "
                + ans[1] + "]");
    }

    public static int[] twoSum(int n,int[] arr,int k){
        int[] ans = new int[2];
        HashMap<Integer,Integer> map = new HashMap<>();
        for (int i =0;i<arr.length;i++){
            int complement = k- arr[i];
            if(map.containsKey(complement)){
                int j = map.get(complement);
                return  new int[] {j,i};
            }
            map.put(arr[i],i);
        }
        return new int[] {-1,-1};
    }
}
