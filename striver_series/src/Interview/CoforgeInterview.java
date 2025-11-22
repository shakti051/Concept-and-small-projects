package Interview;

public class CoforgeInterview {

    public static void main(String[] args) {
        int [] a= {1,2,3,5,6,9};
        int [] b= {2,4,7,8,9,10} ;
        int[] merge = mergeArray(a,b);
        for(int num : merge){
            System.out.print(num+" ");
        }
    }

    public  static int[] mergeArray(int[]a,int []b ){
        int [] result = new int[a.length+ b.length];
        int i =0;
        int j = 0;
        int k = 0;
        while (i<a.length && j< b.length){
            if(a[i]<b[j]){
                result[k++]= a[i++];
            }else{
                result[k++]= b[j++];
            }
        }
        while (i< a.length) result[k++]= a[i++];
        while (j<b.length)result[k++]=b[j++];
        return result;
    }
}
