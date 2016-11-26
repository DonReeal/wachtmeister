package wachtmeister.webapp.csrf;

import io.baratine.web.RequestWeb;
import io.baratine.web.ServiceWeb;
import wachtmeister.webapp.Args;

/**
 * Parses the 'CSRF-TOKEN' from either the request header
 * {@link CSRFToken#HEADER_NAME} or the cookie {@link CSRFToken#COOKIE_NAME}. If
 * a valid token is present it will be attached to the Requests attributes
 * {@link RequestWeb#attribute(CSRFToken)}. Otherwise this filter will raise an
 * {@link CSRFTokenException}.
 * 
 * TODO: might not be a good idea to throw an exception here. Currently this
 * class is used to serve websites directly. A redirect would be more sensible
 * therefore.
 * 
 */
public class RequireCSRFToken implements ServiceWeb {

  public void service(RequestWeb req) {

    String headerToken = req.header(CSRFToken.HEADER_NAME);
    String cookieToken = req.cookie(CSRFToken.COOKIE_NAME);

    String tokenValue = Args.either(headerToken, cookieToken);
    if (tokenValue == null) {
      req.fail(new CSRFTokenException("No CSRF-TOKEN found in cookie or header"));
    } else {
      CSRFToken csrfToken = new CSRFToken(tokenValue);
      req.attribute(csrfToken);
      req.ok();
    }
  }

  
  // TODO: consider checking for csrf here
  
  
  // private boolean isCSRF(CSRFToken domainSentToken, String csrfTokenFromForm)
  // {
  //
  // boolean validToken = CSRFToken.isValid(domainSentToken);
  // boolean tokensEquals =
  // domainSentToken.csrfToken().equals(csrfTokenFromForm);
  // System.out.println("domainSentToken: " + domainSentToken.csrfToken() + " "
  // + validToken);
  // System.out.println("sametoken: " + tokensEquals);
  //
  // return !validToken || !tokensEquals;
  // }

}
