package wachtmeister.logins.simple

import de.oehme.xtend.contrib.logging.slf4j.Slf4j
import io.baratine.service.Service
import io.baratine.web.Web
import wachtmeister.auth.AuthImpl
import wachtmeister.pwhash.PWHashingBCrypt
import wachtmeister.timeline.EventIdsGeneratorService
import wachtmeister.webapp.routes.Home
import wachtmeister.webapp.routes.Login
import wachtmeister.webapp.routes.Signup
import wachtmeister.webapp.routes.Userinfo
import wachtmeister.api.LoginServiceREST
import wachtmeister.jwt.JwtIssuingImpl

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

    Web.start(args)
  }

}
