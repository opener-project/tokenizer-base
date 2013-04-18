
import opennlp.tools.sentdetect.*;
import opennlp.tools.tokenize.*;
import java.io.*;

public class Tokenizer_English {
  public static void main(String args[]) {
    try {
// Check if we have 2 arguments
      if (args.length < 2) {
        System.out.println("\nAplication needs 2 parameters:");
        System.out.println("1. Sentence detection and tokenization model's directory path.");
        System.out.println("2. File's path.");
        System.out.println("You can also specify a 3rd parameter to use static timestamp at KAF header: -n.\n");
      }
      else {
        File f = null;
        FileReader fr = null;
        BufferedReader br = null;
        InputStream smodelIn = null;
        InputStream tmodelIn = null;
        try {
// Create the reader and load the sentence and tokenizer models
          String model_dir = args[0];
          String file = args[1];
          int notimestamp = 0;
          if (args.length > 2)
            notimestamp = 1;

          f = new File(file);
          fr = new FileReader(f);
          br = new BufferedReader(fr);

          smodelIn = new FileInputStream(model_dir + "en-sent.bin");
          tmodelIn = new FileInputStream(model_dir + "en-token.bin");

          SentenceModel smodel = new SentenceModel(smodelIn);
          SentenceDetectorME sentenceDetector = new SentenceDetectorME(smodel);

          TokenizerModel tmodel = new TokenizerModel(tmodelIn);
          TokenizerME tokenizer = new TokenizerME(tmodel);
// Counters for kaf format writing
          String line;
          String sentences[];
          String tokens[];
          int paragraph_count = 1;
          int word_count = 1;
          int sentence_count = 1;
// Print kaf header
          String fileType = null;
          String fileName = null;
          String s = f.getName();
          int is = s.lastIndexOf('.');
          fileName = s.substring(0, is);
          fileType = s.substring(is + 1).toUpperCase();

          Kaf_Text kt = new Kaf_Text();
          Kaf_Header kh = new Kaf_Header("en");
          kh.add_fileDesc_filename(fileName);
          kh.add_fileDesc_filetype(fileType);
          kh.print_xmlroot();
          kh.print_root_open();
          kh.print_openHeader();
          kh.print_fileDesc();

          kh.print_linguisticProcessors_open("text");
          if (notimestamp > 0) {
            kh.print_linguisticProcessors_statictimestamp("openlp-en-sent", "1.0");
            kh.print_linguisticProcessors_statictimestamp("openlp-en-tok", "1.0");
          }
          else {
            kh.print_linguisticProcessors("openlp-en-sent", "1.0");
            kh.print_linguisticProcessors("openlp-en-tok", "1.0");
          }
          kh.print_linguisticProcessors_close();

          kh.print_closeHeader();
          kt.print_openText();
          
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
          if (fr != null) {
            try {
              fr.close();
            }
            catch (IOException e) {
            }
          }
        }
      }
    }
    catch(Exception e) {
      e.printStackTrace();
    }   
  }
}
