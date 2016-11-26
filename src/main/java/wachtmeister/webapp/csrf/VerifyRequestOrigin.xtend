package wachtmeister.webapp.csrf

import de.oehme.xtend.contrib.logging.slf4j.Slf4j
import io.baratine.web.RequestWeb
import io.baratine.web.ServiceWeb
import java.net.URL
import wachtmeister.Strings
import java.net.MalformedURLException

/**
 * https://www.owasp.org/index.php/Cross-Site_Request_Forgery_(CSRF)_Prevention_Cheat_Sheet#General_Recommendations_For_Automated_CSRF_Defense
 * 
 * Quote: 
 * 
 */
 
  // Origin Header: https://tools.ietf.org/id/draft-abarth-origin-03.html
  // "user agent (browser) adds this header to a request to describe the
  // reason it initiated a request
  // content: absolute URI
  // Referer Header: the Ressource (website) that initiated to http-Request
  // example: 
  // 1. do a google search
  // 2. click on a generated link from the displayed the search results (cool.io)
  // 3. user agent will send a referer header: "www.google.com"
  // the headers cannot be modfied by javascript in a browser (unless compromised)
  
// checkStandardHeaders to verify the request is same origin
@Slf4j
class VerifyRequestOrigin implements ServiceWeb {

  static val HEADERNAME_HOST = "HOST"
  static val HEADERNAME_ORIGIN = "ORIGIN"
  static val HEADERNAME_X_FORWARDED_HOST = "X-FORWARDED-HOST"

  override service(RequestWeb request) throws Exception {
    
    if(request.method == "GET") { 
      request.ok
    } else {
      verifyOriginIsFromOurDomain(request)
    }
    
  }

  def verifyOriginIsFromOurDomain(RequestWeb req) {
    
    val originHeader = req.header(HEADERNAME_ORIGIN)
    
    if(Strings.isEmpty(originHeader)) {
      log.error("Empty origin header! Indicates CSRF!")
      error("CSRF!", req)
      return
    }
    
    try {
      
      var originUrl = new URL(originHeader)
      val reqOriginHostAndPort = '''«originUrl.host»:«originUrl.port»'''
      
      val host = req.header(HEADERNAME_HOST) 
        // assume a reverse proxy forwards host in x-forwarded-host header
        ?: req.header(HEADERNAME_X_FORWARDED_HOST)
      
      if(!Strings.equalValue(reqOriginHostAndPort, host)) {
        error("CSRF!", req)
        return
      }
      
      req.ok
      
    } catch(MalformedURLException urlEx) {
      log.error("MalformedURLException - indicates CSRF! origin was: {}", originHeader)
      urlEx.printStackTrace
      error("CSRF!", req)
    }
    
  }

  def error(String message, RequestWeb req) {
    val err = new CSRFTokenException(message)
    req.fail(err)
  }

}
