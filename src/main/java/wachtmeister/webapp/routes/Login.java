package wachtmeister.webapp.routes;

import java.net.InetSocketAddress;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import io.baratine.service.Service;
import io.baratine.web.Body;
import io.baratine.web.FilterBefore;
import io.baratine.web.Form;
import io.baratine.web.Get;
import io.baratine.web.HttpStatus;
import io.baratine.web.Post;
import io.baratine.web.RequestWeb;
import wachtmeister.auth.Auth;
import wachtmeister.jwt.JwtIssuing;
import wachtmeister.webapp.Flash;
import wachtmeister.webapp.WebErrors;
import wachtmeister.webapp.csrf.AttachCSRF;
import wachtmeister.webapp.csrf.CSRFToken;
import wachtmeister.webapp.csrf.RequireCSRFToken;
import wachtmeister.webapp.csrf.VerifyRequestOrigin;
import wachtmeister.webapp.view.WachtmeisterViewBuilder;

@Service
@FilterBefore(VerifyRequestOrigin.class)
public class Login {

  private static final Logger log = LoggerFactory.getLogger(Login.class);

  @Get("/login")
  @FilterBefore(AttachCSRF.class)
  public void renderLoginPage(RequestWeb req) {
    req.ok(new WachtmeisterViewBuilder("login.jade", req).build());
  }

  // @Get("login.error"): https://en.wikipedia.org/wiki/Post/Redirect/Get
  // VS internal redirect ...

  @Post("/login")
  @FilterBefore(RequireCSRFToken.class)
  public void loginViaFormPost(@Body Form form, RequestWeb req) {

    log.info("POST /login!");

    // attached to req by RequireCSRFToken-Filter
    CSRFToken domainSentToken = req.attribute(CSRFToken.class);

    InetSocketAddress clientIp = req.ipRemote();
    FormbasedLoginAttemptData loginAttempt = new FormbasedLoginAttemptData(form.first("csrfToken"),
        form.first("username"), form.first("password"), clientIp.getHostString());

    log.info("loginAttempt: {}", loginAttempt);

    // Detect CSRF -- proof that was the request was sent from our domain
    if (isCSRF(domainSentToken, loginAttempt.csrfTokenFromForm)) {
      log.info("CSRF detected!");
      onCSRF(req);
      return;
    }

    // check identity claimed
    // proof that the passed password hashes to the saved digest
    log.info("handling request from our domain! proceeding ...");
    authenticate(loginAttempt, req);
  }

  // proof that was the request was sent from our domain - csrf prevention
  private boolean isCSRF(CSRFToken domainSentToken, String csrfTokenFromForm) {

    boolean validToken = CSRFToken.isValid(domainSentToken);
    boolean tokensEquals = domainSentToken.csrfToken().equals(csrfTokenFromForm);
    System.out.println("domainSentToken: " + domainSentToken.csrfToken() + "  " + validToken);
    System.out.println("sametoken: " + tokensEquals);

    return !validToken || !tokensEquals;
  }

  private void authenticate(FormbasedLoginAttemptData loginAttempt, RequestWeb req) {

    req.service(Auth.class).verifyIdentity(loginAttempt.username, loginAttempt.password, (isAuthenticated, err) -> {

      if (err != null) {
        WebErrors.toErr(err, req);
        return;
      }

      if (isAuthenticated)
        onAuthenticated(loginAttempt, req);
      else
        onUnauthenticated(req);
    });
  }

  private void onAuthenticated(FormbasedLoginAttemptData loginAttempt, RequestWeb req) {

    JwtIssuing jwtService = req.service(JwtIssuing.class);

    jwtService.createJwt(loginAttempt.username, (jwt, err) -> {

      if (err != null) {
        WebErrors.toErr(err, req);

      } else {

        req.cookie("WACHTMEISTER-TOKEN", jwt).httpOnly(true);
        // how could something like this work without a session-bound
        // server state?
        // cookies with client message codes?
        req.attribute(Flash.notice("Thanks for logging in :) !!!"));
        renderLoginPage(req);
        // req.redirect("/userinfo");
      }

    });

  }

  private void onUnauthenticated(RequestWeb req) {

    System.out.println("== Authentication Failed!");
    System.out.println("Trying to clear cookie!");

    // remove other identity-token
    // can currently only set it to empty
    req.cookie("WACHTMEISTER-TOKEN", "");

    // req.cookieMap().replaceAll((cookieName, oldValue) ->
    // cookieName.equals("WACHTMEISTER-TOKEN")
    // ? ""
    // : oldValue
    // );

    req.status(HttpStatus.FORBIDDEN);
    req.attribute(Flash.error("Wrong Username Or Password!"));

    renderLoginPage(req);
  }

  private void onCSRF(RequestWeb req) {

    req.cookie("WACHTMEISTER-TOKEN", "");

    // req.cookieMap().replaceAll((cookieName, oldValue) ->
    // cookieName.equals("WACHTMEISTER-TOKEN")
    // ? ""
    // : oldValue
    // );

    req.status(HttpStatus.FORBIDDEN);
    req.attribute(Flash.error("Security Warning: You have been maliciously redirected here by another site! (CSRF) "));

    renderLoginPage(req);
  }

}
