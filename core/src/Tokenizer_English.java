
import opennlp.tools.sentdetect.*;
import opennlp.tools.tokenize.*;
import java.io.*;

public class Tokenizer_English {
	private static int HELP = 0;
	private static int NOTIMESTAMP = 0;
	private static String MODELSDIR;
	private static String FILE = "";
	private static void displayHelp() {
		System.err.println("\nThis aplication reads a text from standard input in order to tokenize.");
		System.err.println("Aplication arguments:");
		System.err.println("-l, --lib       sentence detection and tokenization model's directory path.");
		System.err.println("-f, --filename  (optional) file's name.");
		System.err.println("-t,             (optional) o use static timestamp at KAF header.");
		System.err.println("--help,         outputs aplication help.");
	}
	private static int checkArguments(String args[]) {
		int correct = 0;
		if (args.length > 0) 
			for (int i = 0; i < args.length; i++) {
				if(args[i].equalsIgnoreCase("-l"))
					if(args.length > i+1 && !args[i+1].equals("-t") && 
							!args[i+1].equals("-l") && !args[i+1].equals("-f")) {
						MODELSDIR = args[i+1];
						correct = 1;
					}
					else {
						correct = 0;
						System.err.println("Error: model's path empty");
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
						NOTIMESTAMP = 1;
				if(args[i].equalsIgnoreCase("--help"))
					HELP = 1;
			}
		return correct;
	}
	public static void main(String args[]) {
		try {
			if (checkArguments(args) == 1){
				if (HELP == 1)
					displayHelp();
				else {
					BufferedReader br = null;
					InputStream smodelIn = null;
					InputStream tmodelIn = null;
					try {
						// Create the reader and load the sentence and tokenizer models
						br = new BufferedReader(new InputStreamReader(System.in));
	
						smodelIn = new FileInputStream(MODELSDIR + "en-sent.bin");
						tmodelIn = new FileInputStream(MODELSDIR + "en-token.bin");
	
						SentenceModel smodel = new SentenceModel(smodelIn);
						SentenceDetectorME sentenceDetector = new SentenceDetectorME(smodel);
	
						TokenizerModel tmodel = new TokenizerModel(tmodelIn);
						TokenizerME tokenizer = new TokenizerME(tmodel);
						
						// Print kaf header
						Kaf_Header kh = new Kaf_Header("en");
						if (!FILE.isEmpty()) {
							int is = FILE.lastIndexOf('.');
							String fileName = FILE.substring(0, is);
							String fileType = FILE.substring(is + 1).toUpperCase();
							kh.add_fileDesc_filename(fileName);
							kh.add_fileDesc_filetype(fileType);
						}
						
						kh.print_xmlroot();
						kh.print_root_open();
						kh.print_openHeader();
						kh.print_fileDesc();
						kh.print_linguisticProcessors_open("text");
						if (NOTIMESTAMP > 0) {
							kh.print_linguisticProcessors_statictimestamp("openlp-en-sent", "1.0");
							kh.print_linguisticProcessors_statictimestamp("openlp-en-tok", "1.0");
						}
						else {
							kh.print_linguisticProcessors("openlp-en-sent", "1.0");
							kh.print_linguisticProcessors("openlp-en-tok", "1.0");
						}
						kh.print_linguisticProcessors_close();
						kh.print_closeHeader();
						
						Kaf_Text kt = new Kaf_Text();
						kt.print_openText();
						// Counters for kaf format writing
						String line;
						String sentences[];
						String tokens[];
						int paragraph_count = 1;
						int word_count = 1;
						int sentence_count = 1;
						int charcount = 0;
						// Read a paragraph
						while ((line = br.readLine()) != null) {
							// If the paragraph is not empty
							if (line.compareTo("") != 0) {
								// Detect the sentences
								sentences = sentenceDetector.sentDetect(line);
								// for each sentence detect the tokens
								for (int i = 0; i < sentences.length; i++) {
									tokens = tokenizer.tokenize(sentences[i]);
									// print the tokens in kaf format
									int index=0;
									int last_index=0;
									for (int j = 0; j < tokens.length; j++) {
										kt.add_sent(sentence_count);
										kt.add_para(paragraph_count);
										index = line.indexOf(tokens[j], last_index);
										kt.add_offset(charcount + index);
										kt.print_word("w" + word_count, tokens[j]);
										word_count++;
										last_index = index + tokens[j].length();
									}
									sentence_count++;
								}
								paragraph_count++;
							}
							charcount += line.length();
						}
						kt.print_closeText();
						kh.print_root_close();
							
					}
					catch(Exception e) {
						e.printStackTrace();
					}
					finally {
						if (smodelIn != null) {
							try {
								smodelIn.close();
							}
							catch (IOException e) {
							}
						}
						if (tmodelIn != null) {
							try {
								tmodelIn.close();
							}
							catch (IOException e) {
							}
						}
					}
				}
			}
			else
				displayHelp();
		}
		catch(Exception e) {
			e.printStackTrace();
		}   
  	}
}
