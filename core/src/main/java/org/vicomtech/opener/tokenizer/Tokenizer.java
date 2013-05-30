package org.vicomtech.opener.tokenizer;

import opennlp.tools.tokenize.TokenizerME;
import opennlp.tools.tokenize.TokenizerModel;

public class Tokenizer {

	private TokenizerME tokenizer;
	
	public String[] tokenize(String text, String lang){
		TokenizerModel tokenModel=OpenNLPModelManager.getTokenizerModel(lang);
		tokenizer=new TokenizerME(tokenModel);
		return tokenizer.tokenize(text);
	}
	
}
