package wachtmeister.webapp;

public final class Flash {

  public final String error;
  public final String notice;

  private Flash(String notice, String error) {
    this.notice = notice;
    this.error = error;
  }

  public static Flash error(String error) {
    return new Flash("", error);
  }

  public static Flash notice(String notice) {
    return new Flash(notice, "");
  }

}
