import java.util.HashSet;
import java.util.Set;

public class UnionOfArray {

    public static void main(String[] args) {
        int[] arr1 = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        int[] arr2 = {2, 3, 4, 4, 5, 11, 12};
        Set<Integer> unionSet = new HashSet<>();
        for (int num : arr1)
            unionSet.add(num);
        for (int num : arr2)
            unionSet.add(num);
        System.out.println(unionSet);
    }
}

