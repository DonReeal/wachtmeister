package wachtmeister.jwt

import de.oehme.xtend.contrib.logging.slf4j.Slf4j
import io.baratine.config.Config
import io.baratine.service.Result
import io.baratine.service.Service
import io.jsonwebtoken.SignatureAlgorithm
import javax.inject.Inject
import org.eclipse.xtend.lib.annotations.ToString

@Slf4j @ToString
@Service("/JwtIssuing")
class JwtIssuingImpl implements JwtIssuing {
  
  JwtWorker _worker
  
  @Inject new(Config conf) {
    
    val algorithm       = conf.get("jwt.token.signature.algorithm", SignatureAlgorithm, SignatureAlgorithm.HS512)
    val base64StringKey = conf.get("jwt.token.signature.keybase64", "HELLO")
    val issuer          = conf.get("jwt.token.claims.issuer", "wachtmeister")
    val tokenLifetime   = conf.get("jwt.token.lifetimeseconds", Integer, 24*60*60*1000)
    
    log.info("using algorithm: {}" , algorithm)
    _worker = new JwtWorker(
      algorithm, 
      base64StringKey,
      issuer,
      tokenLifetime
    )
    
  }
  
  override void createJwt(String username, Result<String> result) {
    log.info("createJwt(...)")
    result.ok(_worker.createJwt(username))
  }

  override void verifiedGet(String jwts, Result<String> res) {
    log.info("verifiedGet(...)")
    res.ok(_worker.verifyJwt(jwts))
  }
 
 
}
