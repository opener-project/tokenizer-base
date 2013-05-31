package org.vicomtech.opener.tokenizer;

import java.util.ArrayList;
import java.util.List;

public class WordFormGenerator {

	
	public List<WordForm> generateWordForms(String originalText,List<String>textLines, String lang){
		
		Tokenizer tokenizer=new Tokenizer();
		SentenceDetector sentenceDetector=new SentenceDetector();
		
		int wid=1;
		int sentNum=1;
		int line=1;
		int paragraph=1;
		int offset=0;
		//int perLineOffset=0;
		int lastTokenEnd=0;
		//int lineStartOffset=0;
		List<WordForm>wordForms=new ArrayList<WordForm>();
		for(int i=0;i<textLines.size();i++){
			String textLine=textLines.get(i);
			String[]sentences=sentenceDetector.detectSentences(textLine, lang);
			for(String sentence:sentences){
				String[]tokens=tokenizer.tokenize(sentence, lang);
				for(String token:tokens){
					offset=originalText.indexOf(token, lastTokenEnd);
					lastTokenEnd=offset+token.length();
					//offset=lineStartOffset+perLineOffset;
					WordForm wordForm=new WordForm();
					wordForm.setWid(wid++);
					wordForm.setToken(token);
					wordForm.setSentence(sentNum);
					wordForm.setLine(line);
					wordForm.setParagraph(paragraph);
					wordForm.setOffset(offset);
					wordForm.setLength(token.length());
					wordForms.add(wordForm);
				}
				sentNum++;
			}
			line++;
			//reset the perLineOffset
			//perLineOffset=0;
			//+1 to take into account the line break itself (I don't know if this is correct)
			//lineStartOffset+=textLine.length()+2;
			if(shouldIncreaseParagraph(textLines, i)){
				paragraph++;
			}
		}
		return wordForms;
	}
	
	/**
	 * Check whether should the paragraph counter be increased.
	 * If this is the first line, returns false.
	 * If this line is empty but the previous one was also empty, returns false (the paragraph should has been updated in the previous line)
	 * If this line is empty and the previous one was not, returns true.
	 * Return false in other case.
	 * @param textLines
	 * @param currentIndex
	 * @return 
	 */
	public boolean shouldIncreaseParagraph(List<String>textLines,int currentIndex){
		if (currentIndex == 0) {
			return false;
		} else if (textLines.get(currentIndex).trim().equalsIgnoreCase("")) {
			if (textLines.get(currentIndex - 1).trim().equalsIgnoreCase("")) {
				return false;
			} else {
				return true;
			}
		}else{
			return false;
		}
	}
	
}
