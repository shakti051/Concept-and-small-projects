

public class CheckSortedArray {

    public static void main(String[] args) {
        int[] arr = {1, 2, 3, 4, 5};
        int n = arr.length;
        boolean sorted = checkSorted(arr,n);
        System.out.println("The array sorted status is: "+sorted);
    }

    public static boolean checkSorted(int []arr,int n){
        for(int i=1;i<arr.length;i++){
            if(arr[i]<arr[i-1]) {
                return false;
            }
        }
        return  true;
    }
}
