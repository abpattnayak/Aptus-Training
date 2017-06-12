import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;

public class chatBot2 {
	String questions[] = {};

	public static void main(String[] args) throws IOException {
		
		HashMap<Integer,String> hm=new HashMap<Integer,String>();
		HashMap<Integer,String> hsm=new HashMap<Integer,String>();
		
		
		BufferedReader br = new BufferedReader(new FileReader("/home/mapr/Desktop/APTUS/ChatBot/src/stop-words.txt"));
		String line = "";
		int i=0,j=0,noOfWords=0;
		try {
			while ((line=br.readLine()) != null) {
				i++;
				hm.put(i, line);
			}
		} finally {
			br.close();
		}
		br = new BufferedReader(new FileReader("/home/mapr/Desktop/APTUS/ChatBot/src/Questions.txt"));
		line = "";
		
		FileWriter fw = new FileWriter("/home/mapr/Desktop/APTUS/ChatBot/src/trainingOut.txt");
		try {
			j=0;
			while ((line=br.readLine()) != null) {
				line = line.toLowerCase().replaceAll("[^a-z0-9 ]", "");
				j++;
				//hsm.put(j, line);
				System.out.println(line);
				String[] words = line.split("\\s+");
				noOfWords = countNoOfWords(line);
				System.out.println(noOfWords);
				fw.write(noOfWords + "-");
 				for(String word: words){
 					if(!hm.containsValue(word))
 					{
 						fw.write(word + ",");
 					}
 					
 					//System.out.println(word);
 					//System.out.println("hello");
 					
 				}
 				fw.write("\n");
			}
		} finally {
			br.close();
			fw.close();
		}
	}

	private static int countNoOfWords(String line) {
		// TODO Auto-generated method stub
		int counter=0;
		for( int i=0; i<line.length(); i++ ) {
		    if( line.charAt(i) == ' ' ) {
		        counter++;
		    } 
		}
		//System.out.println(counter);
		return counter+1;
	}
}
