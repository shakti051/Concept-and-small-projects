
public class ReverseWords {

    public static void main(String[] args) {
        String str = "My name is Vikas";
        String[] words = str.split("\\s+");
        String result = "";
        for( String word : words){
            String revWord = "";
            for(int i = word.length()-1;i>=0;i--){
                revWord += word.charAt(i);
            }
            result += revWord +" ";
        }
        System.out.println(result);
    }
}