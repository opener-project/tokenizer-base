package org.vicomtech.opener.tokenizer;

import opennlp.tools.sentdetect.SentenceDetectorME;
import opennlp.tools.sentdetect.SentenceModel;

public class SentenceDetector {

	private SentenceDetectorME sentenceDetectorME;
	
	public String[] detectSentences(String text,String lang){
		SentenceModel sentenceModel = OpenNLPModelManager.getSentenceModel(lang);
		sentenceDetectorME=new SentenceDetectorME(sentenceModel);
		return sentenceDetectorME.sentDetect(text);
	}
	
}
