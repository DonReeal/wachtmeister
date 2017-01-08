package wachtmeister.api

import de.oehme.xtend.contrib.logging.slf4j.Slf4j
import io.baratine.service.Service
import io.baratine.web.Path
import io.baratine.web.Post
import io.baratine.web.RequestWeb
import wachtmeister.auth.Auth
import wachtmeister.webapp.WebErrors
import io.baratine.web.Body
import io.baratine.web.Query
import wachtmeister.logins.LoginService
import io.baratine.web.Get
import io.baratine.web.FilterBefore
import wachtmeister.webapp.csrf.VerifyRequestOrigin

@Slf4j
@Service
@Path("/api")
@FilterBefore(VerifyRequestOrigin)
class LoginServiceREST {
  
  /*
  curl -H "Content-Type: application/json" \
  -X POST -d '{"username":"alice","password":"alice"}' \
  http://localhost:3300/api/auth
  */
  @Post("/auth")
  def void auth(RequestWeb req, @Body Credentials cred) {
    log.info("got dis: {}", cred)  
    req.service(Auth).verifyIdentity(
      cred.getUsername,
      cred.getPassword
    )[success, err |
      if(err !== null) WebErrors.toErr(err, req)
      else req.ok(success)
    ]
    
  }
  
  public static final class Credentials {
    
    var String username
    def getUsername() { username }
    def void setUsername(String username) { this.username = username }
    
    var String password
    def getPassword() { password }
    def void setPassword(String password) { this.password = password }
  
  }
  
  /*
  curl -H "Content-Type: application/json" \
  -X GET http://localhost:3300/api/users/usernames?available=cool.captain
  */
  @Get("/users/usernames")
  def void checkUsernameAvailable(
    RequestWeb req, 
    @Query("available") String username
  ) {
    
    log.info("checking availability of username: {}", username)
    req.service(LoginService).isLoginAvailable(username)[isAvailable, err |
      if(err !== null) WebErrors.toErr(err, req)
      else req.ok(isAvailable)
    ]
    
  }
  
  /*
  curl -H "Content-Type: application/json" \
  -X POST -d '{"username":"test","password":"test", "email":"test@test.com"}' \
  http://localhost:3300/api/users
  */
  @Post("/users")
  def void createAccount(RequestWeb req, @Body RegistrationData regData) {
    log.info("requesting create account {}", regData)
    req.service(LoginService).createLogin(
      regData.username,
      regData.password,
      regData.email
    )[id, err |
      if(err !== null) WebErrors.toErr(err, req)
      else req.ok(id)
    ]
  }
  
  public static final class RegistrationData {
    
    String username
    def getUsername() { username }
    def void setUsername(String username) { this.username = username }
    
    String password
    def getPassword() { password }
    def void setPassword(String password) { this.password = password}
    
    String email
    def getEmail() { email }
    def void setEmail(String email) { this.email = email }
    
    override toString() {
      return '''
        RegistrationData[
          username = «username»
          password = ...
          email = ...
       '''
    }
  }
  
  
}