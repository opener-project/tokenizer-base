package org.vicomtech.opener.tokenizer;

import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import opennlp.tools.sentdetect.SentenceModel;
import opennlp.tools.tokenize.TokenizerModel;

public class OpenNLPModelManager {

	private static final String MODELS_DIR="/";
	private static final String SENT_MODELNAME_ENDING="-sent.bin";
	private static final String TOKEN_MODELNAME_ENDING="-token.bin";
	
	private static Map<String,SentenceModel>sentenceModels=new HashMap<String,SentenceModel>();
	private static Map<String,TokenizerModel>tokenizerModels=new HashMap<String,TokenizerModel>();
	
	public static SentenceModel getSentenceModel(String lang){
		SentenceModel sentenceModel=sentenceModels.get(lang);
		if(sentenceModel==null){
			sentenceModel=loadSentenceModel(lang);
			sentenceModels.put(lang, sentenceModel);
		}
		return sentenceModel; 
	}
	
	public static TokenizerModel getTokenizerModel(String lang){
		TokenizerModel tokenizerModel=tokenizerModels.get(lang);
		if(tokenizerModel==null){
			tokenizerModel=loadTokenModel(lang);
			tokenizerModels.put(lang, tokenizerModel);
		}
		return tokenizerModel;
	}
	
	
	public static SentenceModel loadSentenceModel(String lang){
		try{
			InputStream is=OpenNLPModelManager.class.getResourceAsStream(MODELS_DIR+lang+SENT_MODELNAME_ENDING);
			SentenceModel sentenceModel=new SentenceModel(is);
			is.close();
			return sentenceModel;
		}catch(Exception e){
			throw new RuntimeException(e);
		}
	}
	
	public static TokenizerModel loadTokenModel(String lang){
		try{
			InputStream is=OpenNLPModelManager.class.getResourceAsStream(MODELS_DIR+lang+TOKEN_MODELNAME_ENDING);
			TokenizerModel tokenizerModel=new TokenizerModel(is);
			is.close();
			return tokenizerModel;
		}catch(Exception e){
			throw new RuntimeException(e);
		}
	}
	
}
