import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.TimeZone;

public class Kaf_Header {
  private String language;
// filedesc element
  private String author = null;
  private String title = null;
  private String creationtime = null;
  private String filename = null;
  private String filetype = null;
  private String pages = null;
// public element
  private String publicId = null;
  private String uri = null;

  public Kaf_Header(String lang) {
    language = lang;
  }
  public void print_xmlroot() {
    System.out.println("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>");
  }
  public void print_root_open() {
    System.out.println("<KAF xml:lang=\"" + language + "\" version=\"v1.opener\">");
  }
  public void print_root_close() {
    System.out.println("</KAF>");
  }
  public void print_openHeader() {
    System.out.println("  <kafHeader>");
  }
  public void print_closeHeader() {
    System.out.println("  </kafHeader>");
  }
//////////////////////////////
// fileDesc element methods //
//////////////////////////////
  public void add_fileDesc_author(String auth) {
    author = auth;
  }
  public void add_fileDesc_title(String titl) {
    title = titl;
  }
  public void add_fileDesc_creationtime(String crtime) {
    creationtime = crtime;
  }
  public void add_fileDesc_filename(String flname) {
    filename = flname;
  }
  public void add_fileDesc_filetype(String fltype) {
    filetype = fltype;
  }
  public void add_fileDesc_pages(String pg) {
    pages = pg;
  }
  public void print_fileDesc() {
    String fileDesc = "<fileDesc";
    int split = -1;
    if (author != null) {
      fileDesc += " author=\"" + author + "\"";
      if (fileDesc.length() > 45 && split < 0)
        split = fileDesc.length() + 1;
    }
    if (title != null) {
      fileDesc += " title=\"" + title + "\"";
      if (fileDesc.length() > 45 && split < 0)
        split = fileDesc.length() + 1;
    }
    if (creationtime != null) {
      fileDesc += " creationtime=\"" + creationtime + "\"";
      if (fileDesc.length() > 45 && split < 0)
        split = fileDesc.length() + 1;
    }    
    if (filename != null) {
      fileDesc += " filename=\"" + filename + "\"";
      if (fileDesc.length() > 45 && split < 0)
        split = fileDesc.length() + 1;
    }    
    if (filetype != null) {
      fileDesc += " filetype=\"" + filetype + "\"";
      if (fileDesc.length() > 45 && split < 0)
        split = fileDesc.length() + 1;
    }    
    if (pages != null) {
      fileDesc += " pages=\"" + pages + "\"";
      if (fileDesc.length() > 45 && split < 0)
        split = fileDesc.length() + 1;
    }
    fileDesc += " />";
    if (split > 0) {
      System.out.println("    " + fileDesc.substring(0, split));
      System.out.println("\t" + fileDesc.substring(split, fileDesc.length()));
    }
    else
      System.out.println("    " + fileDesc);
  }
////////////////////////////
// public element methods //
////////////////////////////
  public void add_public_publicId(String id) {
    publicId = id;
  }
  public void add_public_uri(String u) {
    uri = u;
  }
  public void print_public() {
    String publ = "<public";
    int split = -1;
    if (publicId != null) {
      publ += " publicId=\"" + publicId + "\"";
      if (uri != null)
        if (uri.length() > 30)
          split = publ.length() + 1;
    }
    if (uri != null) {
      publ += " uri=\"" + uri + "\"";
    }
    publ += " />";

    if (split > 0) {
      System.out.println("    " + publ.substring(0, split));
      System.out.println("\t" + publ.substring(split, publ.length()));
    }
    else
      System.out.println("    " + publ);
  }
//////////////////////////////////////////
// linguisticProcessors element methods //
//////////////////////////////////////////
  public void print_linguisticProcessors_open(String layer) {
    System.out.println("    <linguisticProcessors layer=\"" + layer + "\">");
  }
  public void print_linguisticProcessors(String name, String version) {

    Timestamp ts = new Timestamp(System.currentTimeMillis());
    SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
    fmt.setTimeZone(TimeZone.getTimeZone("GMT"));
    String data = fmt.format(ts);
    fmt = new SimpleDateFormat("HH:mm:ss");
    fmt.setTimeZone(TimeZone.getTimeZone("GMT"));
    String time = fmt.format(ts);
    String timestamp = data + "T" + time + "Z";

    String linguisticProcessors = "<lp name=\"" + name + "\" version=\"" + version + "\" timestamp=\"" + timestamp + "\"/>";
    System.out.println("      " + linguisticProcessors);
  }
  public void print_linguisticProcessors_statictimestamp(String name, String version) {

    String timestamp = "2013-02-05T13:35:22Z";

    String linguisticProcessors = "<lp name=\"" + name + "\" version=\"" + version + "\" timestamp=\"" + timestamp + "\"/>";
    System.out.println("      " + linguisticProcessors);
  }
  public void print_linguisticProcessors_close() {
    System.out.println("    </linguisticProcessors>");
  }
}
