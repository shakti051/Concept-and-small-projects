

public class MaximumOne {

    public static void main(String[] args) {
        int[] arr = {1, 1, 0, 1, 1, 1};
         int count = 0;
         int max = 0;
         for (int num : arr){
             if(num==1){
                 count++;
             }else {count=0;}
         max = Math.max(count,max);
         }
        System.out.println("The max consecutive ones are: "+max);
    }
}

