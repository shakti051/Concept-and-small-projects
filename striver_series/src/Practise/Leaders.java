package Practise;

import java.util.ArrayList;

public class Leaders {
    public static void main(String[] args) {
        int arr[]=  {10, 22, 12, 3, 0, 6};
        int n = arr.length;
        ArrayList<Integer> result = new ArrayList<>();
        int max = arr[n-1];
        result.add(max);
        for(int i = n-2;i>=0;i--){
            if(arr[i]>max){
                max = arr[i];
                result.add(max);
            }
        }
        System.out.println(result);
    }
}
