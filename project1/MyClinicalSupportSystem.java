import jess.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Iterator;
import java.util.Scanner;

public class MyClinicalSupportSystem {

	private static Rete rete;
	private final static String testCaseFile = "test_case6.clp";
	
	public static void printActiveRecommendations() {
		Iterator<Recommendation> recommendations = rete.getObjects(new Filter.ByClass(Recommendation.class));
		while(recommendations.hasNext()){
			Recommendation rec = recommendations.next();
			if(rec.isActive()){
				System.out.println(rec.getDescription() + System.lineSeparator());
			}
		}
	}
	
	public static void printInactiveRecommendations() {
		Iterator<Recommendation> recommendations = rete.getObjects(new Filter.ByClass(Recommendation.class));
		while(recommendations.hasNext()){
			Recommendation rec = recommendations.next();
			if(!rec.isActive()){
				System.out.println(rec.getDescription() + System.lineSeparator());
			}
		}
	}
	
	public static String getTestCaseFile(){
		String fileString = new String();
		System.out.println("Please enter the name of the test-case file or Enter for the default file:");
		Scanner scanny = new Scanner(System.in);
		fileString = scanny.nextLine();
		if(fileString.isEmpty()){
			fileString = testCaseFile;
		}
		if( !fileString.substring(fileString.length() - 4, fileString.length()).equals(".clp")  ){
			fileString += ".clp";
		}
		scanny.close();
		return fileString;
	}
	

	public static void main(String[] args) throws JessException{
		// TODO Auto-generated method stub
		rete = new Rete();
		rete.reset();
		rete.batch("rules.clp");
		try{
			rete.batch( getTestCaseFile() );
		} catch(Exception e) {
			System.out.println("input file not valid, using default file");
			rete.batch( testCaseFile );
		}
		rete.run();
		System.out.println("Recomendations\n");
		printActiveRecommendations();
		//printInactiveRecommendations();
	}
	

}

