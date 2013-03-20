
public class Kaf_Text {

  private int sent = -1;
  private int para = -1;
  private int page = -1;
  private int offset = -1;
  private int length = -1;
  private String xpath = null;

  public void print_openText() {
    System.out.println("  <text>");
  }
  public void print_closeText() {
    System.out.println("  </text>");
  }
  public void add_sent(int sn) {
    sent = sn;
  }
  public void add_para(int pr) {
    para = pr;
  }
  public void add_page(int pg) {
    page = pg;
  }
  public void add_offset(int off) {
    offset = off;
  }
  public void add_length(int ln) {
    length = ln;
  }
  public void add_xpath(String xp) {
    xpath = xp;
  }
  public void print_word(String wid, String word) {
    String text = "<wf wid=\"" + wid + "\"";
    if (sent >= 0 )
      text += " sent=\"" + sent + "\"";
    if (para >= 0 )
      text += " para=\"" + para + "\"";
    if (page >= 0 )
      text += " page=\"" + page + "\"";
    if (offset >= 0 )
      text += " offset=\"" + offset + "\"";
    if (length >= 0 )
      text += " length=\"" + length + "\"";
    if (xpath != null)
      text += " xpath=\"" + xpath + "\"";
    text += ">";
    System.out.println("    " + text + word + "</wf>");
  }
}
