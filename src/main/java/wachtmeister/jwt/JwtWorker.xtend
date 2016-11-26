package wachtmeister.jwt

import de.oehme.xtend.contrib.logging.slf4j.Slf4j
import io.jsonwebtoken.Claims
import io.jsonwebtoken.ExpiredJwtException
import io.jsonwebtoken.Jws
import io.jsonwebtoken.JwtHandlerAdapter
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.MalformedJwtException
import io.jsonwebtoken.SignatureAlgorithm
import io.jsonwebtoken.SignatureException
import io.jsonwebtoken.impl.FixedClock
import java.time.Clock
import java.util.Date
import java.util.UUID

import static wachtmeister.Preconditions.*

@Slf4j
class JwtWorker {
  
  // TODO: http://www.reindel.com/asymmetric-public-key-encryption-using-rsa-java-openssl/
  val SignatureAlgorithm _algorithm
  val String _secretKey
  val String _issuer
  val int _tokenLifetime
  val Clock _clock // TODO: inject global clock
  
  new (
    SignatureAlgorithm algorithm,
    String key,
    String issuer,
    int tokenLifetime
  ) {
    
    requireNotNull(algorithm)
    requireNonEmpty(key)
    requireNonEmpty(issuer)
        
    _algorithm = algorithm
    _secretKey = key
    _issuer = issuer
    _tokenLifetime = tokenLifetime
    _clock = Clock.systemUTC
  
  }

  def String createJwt(String username) {
    
    return (jwtsBuilder() => [
      subject = username
    ]).compact
    
  }

  private def jwtsBuilder() {
    
    val millis = _clock.millis()
    Jwts.builder => [
      signWith(_algorithm, _secretKey)
      id = UUID.randomUUID.toString
      issuer = _issuer
      issuedAt = new Date(millis)
      expiration = new Date(millis + _tokenLifetime)
    ]
    
  }

  def String verifyJwt(String jwsBase64) 
    throws ExpiredJwtException, 
      MalformedJwtException,
      SignatureException {
    
    val parser = Jwts.parser => [
      signingKey = _secretKey
      clock = new FixedClock(new Date(_clock.millis))
    ]
    
    val jws = parser.parse(jwsBase64, new JwtHandlerAdapter<String> {
      override onClaimsJws(Jws<Claims> jws) {
        log.info("jws: {}", jws)      
        return jws.toString
      }
    })
    
    return jws
  }

}
