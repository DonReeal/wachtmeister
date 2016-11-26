package wachtmeister;

public class ServerException extends RuntimeException {
  
  private static final long serialVersionUID = 1L;

  public ServerException(String message) {
    super(message);
  }

  public ServerException(String message, Throwable reason) {
    super(message, reason);
  }

}
