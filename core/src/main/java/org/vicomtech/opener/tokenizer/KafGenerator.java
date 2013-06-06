package org.vicomtech.opener.tokenizer;

import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class KafGenerator {

	private KafFileDescription kafFileDescription;
	private List<WordForm> wordForms;

	private String originalText;
	private List<String> textLines;
	private String lang;
	private boolean withTimestamp;
	private String file = "";
	
	public KafGenerator(String originalText,List<String> textLines,
			String lang, boolean withTimestamp) {
		this.originalText = originalText;
		this.textLines = textLines;
		this.lang = lang;
		this.withTimestamp = withTimestamp;	
	}
	public KafGenerator(String originalText,List<String> textLines,
			String lang, boolean withTimestamp, String file) {
		this.originalText = originalText;
		this.textLines = textLines;
		this.lang = lang;
		this.withTimestamp = withTimestamp;
		this.file = file;
	}
	public String generateKafWithWordFormLayer() {

		kafFileDescription = new KafFileDescription(lang, withTimestamp);
		if (file.length() > 0) {
			int is = file.lastIndexOf('.');
			String fileName = file.substring(0, is);
			String fileType = file.substring(is + 1).toUpperCase();
			kafFileDescription.setFileName(fileName);
			kafFileDescription.setFileType(fileType);
		}

		WordFormGenerator wordFormGenerator = new WordFormGenerator();
		wordForms = wordFormGenerator.generateWordForms(originalText,textLines, lang);

		//System.out.println("Wordforms size: "+wordForms.size());
		
		DocumentBuilderFactory docFactory = DocumentBuilderFactory
				.newInstance();
		DocumentBuilder docBuilder;
		try {
			docBuilder = docFactory.newDocumentBuilder();
			// root elements
			Document doc = docBuilder.newDocument();
			Element kafRoot = doc.createElement("KAF");
			kafRoot.setAttribute("xml:lang", lang);
			kafRoot.setAttribute("version", "v1.opener");

			Element kafHeader = doc.createElement("kafHeader");
			if (kafFileDescription.getFileName().length() > 0) {
				Element fileDesc = doc.createElement("fileDesc");
				fileDesc.setAttribute("filename", kafFileDescription.getFileName());
				fileDesc.setAttribute("filetype", kafFileDescription.getFileType());
				kafHeader.appendChild(fileDesc);
			}
			Element linguisticProcessors = doc
					.createElement("linguisticProcessors");
			linguisticProcessors.setAttribute("layer",
					kafFileDescription.getLayer());
			Element lpTok = doc.createElement("lp");
			lpTok.setAttribute("name",
					kafFileDescription.getLinguisticProcessorNameTok());
			lpTok.setAttribute("timestamp", kafFileDescription.getTimestamp());
			lpTok.setAttribute("version",
					kafFileDescription.getLinguisticProcessorVersion());

			Element lpSent = doc.createElement("lp");
			lpSent.setAttribute("name",
					kafFileDescription.getLinguisticProcessorNameSent());
			lpSent.setAttribute("timestamp", kafFileDescription.getTimestamp());
			lpSent.setAttribute("version",
					kafFileDescription.getLinguisticProcessorVersion());
			
			Element text = doc.createElement("text");
			for (WordForm wordForm : wordForms) {
				Element wf = doc.createElement("wf");
				if (wordForm.getWid() > -1)
					wf.setAttribute("wid", "w"+wordForm.getWid() + "");
				if (wordForm.getSentence() > -1)
					wf.setAttribute("sent", wordForm.getSentence() + "");
				if (wordForm.getParagraph() > -1)
					wf.setAttribute("para", wordForm.getParagraph()+"");
				if (wordForm.getPage() > -1)
					wf.setAttribute("page", wordForm.getPage()+"");
				if (wordForm.getOffset() > -1)
					wf.setAttribute("offset", wordForm.getOffset() + "");
				if (wordForm.getLength() > -1)
					wf.setAttribute("length", wordForm.getLength() + "");
				if (wordForm.getXPath().length() > 0)
					wf.setAttribute("xpath", wordForm.getXPath());
				wf.setTextContent(wordForm.getToken());
				text.appendChild(wf);
			}

			kafRoot.appendChild(kafHeader);
			kafHeader.appendChild(linguisticProcessors);
			linguisticProcessors.appendChild(lpTok);
			linguisticProcessors.appendChild(lpSent);
			kafRoot.appendChild(text);
			doc.appendChild(kafRoot);

			StringWriter stringWriter = new StringWriter();
			Transformer transformer = TransformerFactory.newInstance().newTransformer();
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
			transformer.transform(new DOMSource(doc), new StreamResult(
					stringWriter));
			String strFileContent = stringWriter.toString();
			return strFileContent;
			
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (TransformerConfigurationException e) {
			e.printStackTrace();
		} catch (TransformerFactoryConfigurationError e) {
			e.printStackTrace();
		} catch (TransformerException e) {
			e.printStackTrace();
		}
		return null;
	}
}
