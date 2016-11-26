package wachtmeister.webapp.csrf;

import java.util.UUID;

import wachtmeister.Strings;

public class CSRFToken {

  public static final String COOKIE_NAME = "CSRF-TOKEN";
  public static final String HEADER_NAME = "X-CSRF-TOKEN";
  public static final String FORM_NAME = "csrfToken";

  private String csrfToken;

  public String csrfToken() {
    return csrfToken;
  };

  public CSRFToken(String value) {
    this.csrfToken = value;
  }

  public static CSRFToken init() {
    // should be cryptographic strong random value
    return new CSRFToken(UUID.randomUUID().toString());
  }

  public static boolean isValid(CSRFToken t) {
    if (Strings.isNonEmpty(t.csrfToken)) {
      if (t.csrfToken.length() > 12) {
        return true;
      }
    }
    return false;
  }

}
