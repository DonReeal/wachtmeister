package wachtmeister.webapp.routes;

import io.baratine.service.Service;
import io.baratine.web.FilterBefore;
import io.baratine.web.Get;
import io.baratine.web.RequestWeb;
import wachtmeister.jwt.JwtIssuing;
import wachtmeister.webapp.WebErrors;
import wachtmeister.webapp.jwt.VerifyJWTIntegrity;
import wachtmeister.webapp.view.WachtmeisterViewBuilder;

@Service("/userinfo")
public class Userinfo {

  @Get("/userinfo")
  @FilterBefore(VerifyJWTIntegrity.class)
  public void getUserInfo(RequestWeb req) {

    // TODO: open issue on baratines github
    req.attribute(new Object()); // unless called RequestWrapper.delegate() is
                                 // null here
    String c = req.cookie("WACHTMEISTER-TOKEN");

    req.service(JwtIssuing.class).verifiedGet(c, (clearToken, err) -> {
      
      if (err != null) {
        WebErrors.toErr(err, req);
        return;
      }
      
      req.ok(new WachtmeisterViewBuilder("userinfo.jade", req).set("jwt", clearToken).build());
   
    });
  }

}
