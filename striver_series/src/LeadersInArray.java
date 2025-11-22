import java.util.ArrayList;

public class LeadersInArray {

    public static void main(String[] args) {
        int[] arr=  {10, 22, 12, 3, 0, 6};
        ArrayList<Integer> leaders = new ArrayList<>();
        int max = arr[arr.length-1];
        leaders.add(max);
        for (int i = arr.length-2;i>=0;i--){
            if(arr[i]>max){
                leaders.add(arr[i]);
                max = arr[i];
            }
        }
        System.out.println(leaders );
    }
}
