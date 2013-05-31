package org.vicomtech.opener.tokenizer;

import static org.junit.Assert.*;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

public class TokenizerMainTest {

	@Test
	public void testTokenizerMain() {
		
		String str="This is a tokenizer test. It should work! More-or-less...\nNew line to test the offset issue.";
		InputStream is = new ByteArrayInputStream(str.getBytes());
		String[]args={"-l","en","-t"};
		Main.execute(is, System.out, args);
		
		
		assertTrue(true);
	}

	@Test
	public void testOffsets() {
		WordFormGenerator wordFormGenerator=new WordFormGenerator();
		
		String example="This is a tokenizer test. It should work!\nNew line...";
		String[]lines=example.split("\n");
		
		System.out.println("Index of \\n: "+example.indexOf("\n"));
		System.out.println("Length of \\n: "+"\n".length());
		
		List<String>textLines=new ArrayList<String>();	
		System.out.println("Example length: "+example.length()+" Lines length: "+lines.length);
		System.out.println(lines[0]);
		System.out.println(lines[1]);
		textLines.add(lines[0]);
		textLines.add(lines[1]);
		
		List<WordForm> wfs = wordFormGenerator.generateWordForms(example,textLines, "en");
		
		for(WordForm wf:wfs){
			try{
			System.out.print(example.substring(wf.getOffset(), wf.getOffset()+wf.getLength())+"|||");
			}catch(Exception e){
				System.out.println("ERROR: "+e.getMessage());
				System.out.println(wf);
			}
			
			
		}
		
		for(WordForm wf:wfs){
			System.out.println(wf);
		}
		
	}
	
}
