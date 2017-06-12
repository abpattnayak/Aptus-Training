import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

public class botTest {
	
	private static Map<Integer,List<String>> hm = new HashMap<Integer,List<String>>();
	
	public static void main(String[] args) throws IOException{
		
		
		BufferedReader br = new BufferedReader(new FileReader("/home/mapr/Desktop/APTUS/ChatBot/src/trainingOut.txt"));
		String line = "";
		int i=0,j=0;
		//List<Double> trainingScores = new ArrayList<Double>();
		
		try {
			
			while ((line=br.readLine()) != null) {
				i++;
				line = line.substring(0,line.length()-1);
				
				//System.out.println(line);
				
				String[] temp1 = line.split("-");
				
				List<String> temp2 = new ArrayList<String>();
								
				String[] temp3 = temp1[1].split(",");
				temp2.add(temp1[0]);
				for(String word : temp3){
					temp2.add(word);
					hm.put(i, temp2);
				}	
			}
		} finally {
			br.close();
		}
		
		
		
		for(Map.Entry<Integer, List<String>> entry : hm.entrySet()){
			Integer key = entry.getKey();
            List<String> values = entry.getValue();
            System.out.println("Key = " + key);
            System.out.println("Values = " + values + "n");
		}
		
		double[] score;
		String query = "";
		Scanner reader = new Scanner(System.in);
		System.out.println("Enter query ");
		query = reader.nextLine();
		
		query = query.toLowerCase().replaceAll("[^a-z0-9 ]", "");
		String[] queryWords = query.split(" ");
		i=0;
		for(Map.Entry<Integer, List<String>> entry : hm.entrySet()){
			Integer key = entry.getKey();
            List<String> values = entry.getValue();
            if(values.contains(o)){
            	
            }
            i++;
		}
		
	}
	
}
