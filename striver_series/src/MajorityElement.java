
public class MajorityElement {
    public static void main(String[] args) {
        int[] arr = {2, 2, 1, 1, 1, 2, 2};

        int ans = majorityElement(arr);
        System.out.println(ans);
    }
    private static int majorityElement(int [] arr){
        int count = 0;
        int element = 0;
        for(int num : arr){
           if(count == 0)
               element = num;
           if(num==element)count++;
           else count--;
           if (count>arr.length/2)
               return element;
        }
        return element;
    }
}
