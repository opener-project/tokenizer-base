package org.vicomtech.opener.tokenizer;

import java.io.StringWriter;
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

	public String generateKafWithWordFormLayer(String originalText,List<String> textLines,
			String lang, boolean withTimestamp) {

		kafFileDescription = new KafFileDescription(lang, withTimestamp);

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
				wf.setAttribute("wid", "w"+wordForm.getWid() + "");
				wf.setAttribute("sent", wordForm.getSentence() + "");
				 wf.setAttribute("para", wordForm.getParagraph()+"");
				wf.setAttribute("offset", wordForm.getOffset() + "");
				wf.setAttribute("length", wordForm.getLength() + "");
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
