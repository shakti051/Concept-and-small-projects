import java.util.HashMap;
import java.util.Map;

public class HighLowFeequency {

    public static void main(String[] args) {
        int[] arr = {10, 5, 10, 15, 10, 5};
        Map<Integer,Integer> frequencyMap = new HashMap<>();
        for (int num : arr)
        {
            frequencyMap.put(num, frequencyMap.getOrDefault(num,0)+1);
        }
        /** Step 2: Initialize variables to track highest and lowest frequency **/
        int maxFreq = Integer.MIN_VALUE;
        int minFreq = Integer.MAX_VALUE;
        int minEle = -1;
        int maxEle = -1;

        for(Map.Entry<Integer,Integer> entry : frequencyMap.entrySet()){
            int element = entry.getKey();
            int freq = entry.getValue();

            if(freq > maxFreq){
                maxFreq = freq;
                maxEle = element;
            }
            if(freq < minFreq){
                minFreq = freq;
                minEle = element;
            }
        }

        System.out.println( "Frequencies" + frequencyMap);
        System.out.println("Max freq element "+maxEle +", "+maxFreq +" Times");
        System.out.println("Min freq element "+minEle +", "+minFreq +" Times");

    }
}
