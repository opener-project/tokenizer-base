package org.vicomtech.opener.tokenizer;

public class WordForm {

	private int wid = -1;
	private String token = "";
	private int line = -1;
	private int sentence = -1;
	private int paragraph = -1;
	private int page = -1;
	private int offset = -1;
	private int length = -1;
	private String xpath = "";

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public int getLine() {
		return line;
	}

	public void setLine(int line) {
		this.line = line;
	}

	public int getSentence() {
		return sentence;
	}

	public void setSentence(int sentence) {
		this.sentence = sentence;
	}

	public int getParagraph() {
		return paragraph;
	}

	public void setParagraph(int paragraph) {
		this.paragraph = paragraph;
	}
	
	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public int getOffset() {
		return offset;
	}

	public void setOffset(int offset) {
		this.offset = offset;
	}

	public int getLength() {
		return length;
	}

	public void setLength(int length) {
		this.length = length;
	}

	public int getWid() {
		return wid;
	}

	public void setWid(int wid) {
		this.wid = wid;
	}
	
	public String getXPath() {
		return xpath;
	}

	public void setXPath(String xpath) {
		this.xpath = xpath;
	}

	@Override
	public String toString() {
		return "WordForm [wid=" + wid + ", token=" + token + ", line=" + line
				+ ", sentence=" + sentence + ", paragraph=" + paragraph
				+ ", page=" + page +", offset=" + offset + ", length=" + length
				+ ", xpath=" + xpath + "]";
	}

}
