package org.vicomtech.opener.tokenizer;

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class Main {

	private static Set<String>validLangs;
	private static String LANG = "";
	private static String FILE = "";
	private static int HELP;
	private static boolean WITHTIMESTAMP = true;
	static{
		validLangs=new HashSet<String>();
		validLangs.add("en");
		validLangs.add("es");
		//validLangs.add("fr");
		validLangs.add("it");
		validLangs.add("nl");
		validLangs.add("de");
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {

		execute(System.in, System.out, args);
	}

	public static void execute(InputStream is, OutputStream os, String[] args) {
		if (checkArguments(args) == 1){
			if (HELP == 1)
				displayHelp();
			else {
				/*KafGenerator kafGenerator = new KafGenerator();
				boolean withTimestamp = true;
				String lang = null;
				for (int index = 0; index < args.length; index++) {
					if (args[index].equalsIgnoreCase("-t")) {
						withTimestamp = false;
					}
					if (args[index].equalsIgnoreCase("-l") && index < args.length - 1) {
						lang = args[index + 1];
					}
				}
		
				if(!validLangs.contains(lang)){
					throw new RuntimeException("Invalid language: "+lang);
				}*/
				
				BufferedReader br = new BufferedReader(new InputStreamReader(is));
				List<String> textLines = new ArrayList<String>();
				String line = "";
				String originalText="";
				try {
					while ((line = br.readLine()) != null) {
						originalText+=line+"\n";
						textLines.add(line.trim());
					}
					br.close();
					
					//System.out.println("textLines size: "+textLines.size());
					String kafString;
					KafGenerator kafGenerator;
					if (FILE.length() > 0)
						kafGenerator = new KafGenerator(originalText,textLines, 
								LANG, WITHTIMESTAMP, FILE);
					else
						kafGenerator = new KafGenerator(originalText,textLines, 
								LANG, WITHTIMESTAMP);
					kafString = kafGenerator.generateKafWithWordFormLayer();
					BufferedOutputStream bos = new BufferedOutputStream(os);
					bos.write(kafString.getBytes());
					bos.flush();
					bos.close();
		
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		else
			displayHelp();
	}
	private static int checkArguments(String args[]) {
		int correct = 0;
		if (args.length > 0) 
			for (int i = 0; i < args.length; i++) {
				if(args[i].equalsIgnoreCase("-l"))
					if(args.length > i+1 && !args[i+1].equals("-t") && 
							!args[i+1].equals("-l") && !args[i+1].equals("-f")) {
						LANG = args[i+1];
						correct = 1;
						if(!validLangs.contains(LANG)){
							System.err.println("Error: Invalid language " + LANG);
							correct = 0;
						}
						else
							correct = 1;
					}
					else {
						System.err.println("Error: Invalid language");
						correct = 0;
					}
				if(args[i].equalsIgnoreCase("-f"))
					if(args.length > i+1 && !args[i+1].equals("-t") && 
							!args[i+1].equals("-l") && !args[i+1].equals("-f")) {
						FILE = args[i+1];
					}
					else {
						correct = 0;
						System.err.println("Error: file's name empty");
					}
				if(args[i].equalsIgnoreCase("-t"))
					if(args.length > i)
						WITHTIMESTAMP = false;
				if(args[i].equalsIgnoreCase("--help"))
					HELP = 1;
			}
		
		return correct;
	}
	private static void displayHelp() {
		System.err.println("\nThis aplication reads a text from standard input in order to tokenize.");
		System.err.println("Aplication arguments:");
		System.err.println("-l, --lang      input text's language.");
		System.err.println("-f, --filename  (optional) file's name.");
		System.err.println("-t,             (optional) use static timestamp at KAF header.");
		System.err.println("--help,         outputs aplication help.");
	}
}
