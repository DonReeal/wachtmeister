package wachtmeister.webapp.routes;

import io.baratine.service.Service;
import io.baratine.web.Body;
import io.baratine.web.FilterBefore;
import io.baratine.web.Form;
import io.baratine.web.Get;
import io.baratine.web.Post;
import io.baratine.web.RequestWeb;
import wachtmeister.ServerException;
import wachtmeister.jwt.JwtIssuing;
import wachtmeister.logins.LoginAlreadyTakenException;
import wachtmeister.logins.LoginService;
import wachtmeister.webapp.Flash;
import wachtmeister.webapp.WebErrors;
import wachtmeister.webapp.csrf.AttachCSRF;
import wachtmeister.webapp.csrf.CSRFToken;
import wachtmeister.webapp.csrf.RequireCSRFToken;
import wachtmeister.webapp.view.WachtmeisterViewBuilder;

@Service("/signup")
public class Signup {

	@Get("/signup")
	@FilterBefore(AttachCSRF.class)
	public void getSignupPage(RequestWeb req) {
		
		CSRFToken t = req.attribute(CSRFToken.class);
		
		req.cookie(CSRFToken.COOKIE_NAME, t.csrfToken())
			.httpOnly(true)
			.path("/signup");
		
		req.ok(new WachtmeisterViewBuilder("signup.jade", req).build());
	}

	@Post("/signup")
	@FilterBefore(RequireCSRFToken.class)
	public void submitSignupForm(@Body Form form, RequestWeb req) {
		
		LoginService loginService = req.service(LoginService.class);
		String login = form.first("login");
		String email = form.first("email");
		String pw = form.first("password");
		
		loginService.createLogin(login, pw, email, (identityCreated, err) -> {
			if (err != null) {
				if (err instanceof LoginAlreadyTakenException) {
					req.attribute(Flash.error("Login already taken!"));
					getSignupPage(req);
				}
				else {
					WebErrors.toErr(err, req);
				}
			} else {
				System.out.println("welcome user you created your identity? " + identityCreated);
				onIdentityCreated(login, req);
			}
		});
	}

	private void onIdentityCreated(String username, RequestWeb req) {

		req.service(JwtIssuing.class).createJwt(username, (jwt, err) -> {
			if (err != null) {
				req.fail(new ServerException("Sorry something went wrong :(", err));
			
			} else {
				
				// clear all old sessions ...
//				req.cookieMap().replaceAll((cookieName, oldValue) -> 
//					cookieName.equals("WACHTMEISTER-TOKEN")
//					? ""
//					: oldValue);
				
				req.cookie("WACHTMEISTER-TOKEN", jwt).httpOnly(true);
				req.redirect("/userinfo");
			}
		});

	}

}
