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
import wachtmeister.Strings;
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

  private static final Logger LOG = LoggerFactory.getLogger(Login.class);

  @Get("/login")
  @FilterBefore(AttachCSRF.class)
  public void renderLoginPage(RequestWeb req) {
    req.ok(new WachtmeisterViewBuilder("login.jade", req).build());
  }

  // TODO: how should wachtmeister redirect?
  // @Get("login.error"): https://en.wikipedia.org/wiki/Post/Redirect/Get => state synchronization between requests
  // VS internal redirect => state can be used within same request e.g. to prerender form based on last request state

  @Post("/login")
  @FilterBefore(RequireCSRFToken.class)
  public void loginViaFormPost(@Body Form form, RequestWeb req) {

    LOG.info("POST /login!");

    // attached to req by RequireCSRFToken-Filter
    CSRFToken domainSentToken = req.attribute(CSRFToken.class);
    InetSocketAddress clientIp = req.ipRemote();
    
    LoginAttemptData loginAttempt = LoginAttemptData.builder()
        .setUsername(form.first("username"))
        .setPassword(form.first("password"))
        .setCsrfToken(form.first("csrfToken"))
        .setClienIpAdress(clientIp.getHostString())
        .build();

    LOG.info("Handling login attempt: {}", loginAttempt);

    if (isCSRF(domainSentToken, loginAttempt)) {
      LOG.info("CSRF detected!");
      onCSRF(req);
      return;
    }
    
    LOG.info("handling request from our domain! Proceeding to authentication...");
    
    authenticate(loginAttempt, req);
  }

  // Detect CSRF -- proof that was the request was sent from our domain
  private boolean isCSRF(CSRFToken domainSentToken, LoginAttemptData loginAttempt) {
    
    boolean validToken = CSRFToken.isValid(domainSentToken);
    boolean tokensEquals =  Strings.equalValue(domainSentToken.csrfToken(), loginAttempt.getCsrfToken());
    
    return !(validToken & tokensEquals);
  }

  private void authenticate(LoginAttemptData loginAttempt, RequestWeb req) {

    req.service(Auth.class).verifyIdentity(
        loginAttempt.getUsername(), 
        loginAttempt.getPassword(), 
        (isAuthenticated, err) -> {
          
          if (err != null) { WebErrors.toErr(err, req); return; }          
          
          if (isAuthenticated) {
            onAuthSuccess(loginAttempt, req);
          } else {
            onAuthFailed(req);
          }
          
        }
    );
  }

  private void onAuthSuccess(LoginAttemptData loginAttempt, RequestWeb req) {


    req.service(JwtIssuing.class).createJwt(loginAttempt.getUsername(), (jwt, err) -> {

      if (err != null) {
        WebErrors.toErr(err, req);
        return;    
      } 

      req.cookie("WACHTMEISTER-TOKEN", jwt).httpOnly(true);
      req.attribute(Flash.notice("Thanks for logging in :) !!!"));  
      renderLoginPage(req);
    
    });

  }

  private void onAuthFailed(RequestWeb req) {

    // remove other identity-token - no guarantees that the client will actually dispose the value
    req.cookie("WACHTMEISTER-TOKEN", "");
    
    req.status(HttpStatus.FORBIDDEN);
    req.attribute(Flash.error("Wrong Username Or Password!"));

    renderLoginPage(req);
  }

  private void onCSRF(RequestWeb req) {

    req.cookie("WACHTMEISTER-TOKEN", "");

    req.status(HttpStatus.FORBIDDEN);
    req.attribute(Flash.error("Security Warning: You have been maliciously redirected here by another site! (CSRF) "));

    renderLoginPage(req);
  }

}
