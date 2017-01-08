package wachtmeister.logins.simple

import de.oehme.xtend.contrib.logging.slf4j.Slf4j
import io.baratine.service.Service
import io.baratine.web.Web
import wachtmeister.api.LoginServiceREST
import wachtmeister.auth.AuthImpl
import wachtmeister.jwt.JwtIssuingImpl
import wachtmeister.pwhash.PWHashingBCrypt
import wachtmeister.timeline.EventIdsGeneratorService
import wachtmeister.webapp.routes.Home
import wachtmeister.webapp.routes.Login
import wachtmeister.webapp.routes.Signup
import wachtmeister.webapp.routes.Userinfo

@Service
@Slf4j
class SimpleLoginServer {

  static def void main(String[] args) {

    Web.port(3300)

    // unless called no resources will be found 
    // outside of "resources/public" folder
    Web.scanAutoConf
    Web.property("view.jade.templates", "classpath:/views/")

    // pod events
    Web.include(EventIdsGeneratorService)

    // pod auth
    Web.include(PWHashingBCrypt)
    Web.include(AuthImpl)

    // pod logindata
    Web.include(SingleAssetLoginService)

    // api
    Web.include(LoginServiceREST)

    // pod web
    Web.include(JwtIssuingImpl)
    Web.include(Home)
    Web.include(Signup)
    Web.include(Login)
    Web.include(Userinfo)

    println('''
      .....    s-t-a-r-t-i-n-g       .....
      
       ____ ____ ____ ____ ____ ____ ____ 
      ||w |||a |||c |||h |||t |||: |||: ||
      ||__|||__|||__|||__|||__|||__|||__||
      |/__\|/__\|/__\|/__\|/__\|/__\|/__\|
       ____ ____ ____ ____ ____ ____ ____ 
      ||m |||e |||i |||s |||t |||e |||r ||
      ||__|||__|||__|||__|||__|||__|||__||
      |/__\|/__\|/__\|/__\|/__\|/__\|/__\|
      
    ''')
    
    
//    val level = Level.FINEST;
//    Logger.getLogger("com.caucho").setLevel(level);
//    Logger.getLogger("examples").setLevel(level);
//    Logger.getLogger("core").setLevel(level);

    try {
      Web.start(args);
    } catch (Exception e) {
      e.printStackTrace();
    }
    
  }

}
