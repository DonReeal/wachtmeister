package wachtmeister.webapp.jwt

import de.oehme.xtend.contrib.logging.slf4j.Slf4j
import io.baratine.web.HttpStatus
import io.baratine.web.RequestWeb
import io.baratine.web.ServiceWeb
import wachtmeister.Strings
import wachtmeister.jwt.JwtIssuing

@Slf4j
class VerifyJWTIntegrity implements ServiceWeb {

  // TODO: WachtmeisterClaims <= Jws<Claims> should be attached to the request later on
  // 
  override void service(RequestWeb req) {

    val cookieValue = req.cookie("WACHTMEISTER-TOKEN")
    
    if(Strings.isEmpty(cookieValue)) {  
      log.info("No WACHTMEISTER-TOKEN cookie found.")
      unauthorized(req)
      return;
    }
    
    req.service(JwtIssuing).verifiedGet(cookieValue, [ clearToken, err |
      
      if(err !== null) {        
        log.error("Error verifying jwt. Msg was: {}", err.message)
        unauthorized(req)        
      } else {
        req.ok()
      }
    ])
    
  }

  def private void unauthorized(RequestWeb req) {
    req.status(HttpStatus.UNAUTHORIZED)
    req.redirect("/login")
  }
}
