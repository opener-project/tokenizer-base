package org.vicomtech.opener.tokenizer;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.TimeZone;

public class KafFileDescription {

	private String layer="text";
	private String linguisticProcessorNameTok;
	private String linguisticProcessorNameSent;
	private String linguisticProcessorVersion="1.0";
	
	private String title;
	private String author;
	private String creationTime;
	private String fileName;
	private String fileType;
	private String pages;	
	
	private boolean withTimestamp;

	public KafFileDescription(String lang,boolean withTimestamp) {
		this.linguisticProcessorNameTok="opennlp-"+lang+"-tok";
		this.linguisticProcessorNameSent="opennlp-"+lang+"-sent";
		this.withTimestamp = withTimestamp;
	}

	public String getTimestamp() {
		Timestamp ts = new Timestamp(System.currentTimeMillis());
		SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
		fmt.setTimeZone(TimeZone.getTimeZone("GMT"));
		String data = fmt.format(ts);
		fmt = new SimpleDateFormat("HH:mm:ss");
		fmt.setTimeZone(TimeZone.getTimeZone("GMT"));
		String time = fmt.format(ts);
		String timestamp = data + "T" + time + "Z";

		if (!withTimestamp) {
			timestamp=timestamp.replaceAll("[0-9]", "0");
		}
		return timestamp;
	}
	
	public String getLayer() {
		return layer;
	}

	public void setLayer(String layer) {
		this.layer = layer;
	}

	public String getLinguisticProcessorNameTok() {
		return linguisticProcessorNameTok;
	}

	public void setLinguisticProcessorNameTok(String linguisticProcessorNameTok) {
		this.linguisticProcessorNameTok = linguisticProcessorNameTok;
	}

	public String getLinguisticProcessorNameSent() {
		return linguisticProcessorNameSent;
	}

	public void setLinguisticProcessorNameSent(String linguisticProcessorNameSent) {
		this.linguisticProcessorNameSent = linguisticProcessorNameSent;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public String getCreationTime() {
		return creationTime;
	}

	public void setCreationTime(String creationTime) {
		this.creationTime = creationTime;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFileType() {
		return fileType;
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	public String getPages() {
		return pages;
	}

	public void setPages(String pages) {
		this.pages = pages;
	}

	public boolean isWithTimestamp() {
		return withTimestamp;
	}

	public void setWithTimestamp(boolean withTimestamp) {
		this.withTimestamp = withTimestamp;
	}

	public String getLinguisticProcessorVersion() {
		return linguisticProcessorVersion;
	}

	public void setLinguisticProcessorVersion(String linguisticProcessorVersion) {
		this.linguisticProcessorVersion = linguisticProcessorVersion;
	}

	
}
