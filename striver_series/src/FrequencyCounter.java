import java.util.HashMap;
import java.util.Map;

public class FrequencyCounter {

    public static void main(String[] args) {

        int[] arr = {10, 5, 10, 15, 10, 5};
        Map<Integer,Integer> frequencyMap = new HashMap<>();

        for(int num : arr)
        {
            frequencyMap.put(num,frequencyMap.getOrDefault(num,0)+1);
        }
        for(Map.Entry<Integer,Integer> entry: frequencyMap.entrySet()){
            System.out.println(entry.getKey() +" ,"+ entry.getValue()+ " Times");
        }
    }
}
