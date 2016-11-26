package wachtmeister.webapp.csrf;

import io.baratine.web.RequestWeb;
import io.baratine.web.ServiceWeb;

public class AttachCSRF implements ServiceWeb {

  @Override
  public void service(RequestWeb request) throws Exception {

    CSRFToken csrf = CSRFToken.init();
    request.attribute(csrf);

    String path = request.path();
    request.cookie(CSRFToken.COOKIE_NAME, csrf.csrfToken()).path(path).httpOnly(true);
    request.ok();
  }

}
