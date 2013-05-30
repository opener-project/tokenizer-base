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

		KafGenerator kafGenerator = new KafGenerator();
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
		}
		
		BufferedReader br = new BufferedReader(new InputStreamReader(is));
		List<String> textLines = new ArrayList<String>();
		String line = "";
		try {
			while ((line = br.readLine()) != null) {
				textLines.add(line.trim());
			}
			br.close();
			
			//System.out.println("textLines size: "+textLines.size());
			String kafString = kafGenerator.generateKafWithWordFormLayer(
					textLines, lang, withTimestamp);

			//System.out.println(kafString);
			BufferedOutputStream bos = new BufferedOutputStream(os);
			bos.write(kafString.getBytes());
			bos.flush();
			bos.close();

		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
