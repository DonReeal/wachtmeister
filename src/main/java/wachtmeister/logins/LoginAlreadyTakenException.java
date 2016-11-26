package wachtmeister.logins;

import wachtmeister.ClientException;

public class LoginAlreadyTakenException extends ClientException {

  private static final long serialVersionUID = 1L;

  public LoginAlreadyTakenException(String msg) {
    super(msg);
  }

  public LoginAlreadyTakenException(String msg, Throwable reason) {
    super(msg, reason);
  }
}
