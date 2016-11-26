package wachtmeister.webapp.csrf;

public class CSRFTokenException extends RuntimeException {

  private static final long serialVersionUID = 1L;

  public CSRFTokenException(String msg) {
    super(msg);
  }

}
