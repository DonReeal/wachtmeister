package wachtmeister.auth

import de.oehme.xtend.contrib.logging.slf4j.Slf4j
import io.baratine.service.Result
import io.baratine.service.Service
import javax.inject.Inject
import pollbus.idgen.barflake.BarflakeDecoder
import wachtmeister.logins.LoginService
import wachtmeister.pwhash.PWHashingService
import wachtmeister.timeline.EventIds

import static wachtmeister.service.ServiceInvocations.defaultValueOnUncaughtError

@Slf4j
@Service("/Auth")
class AuthImpl implements Auth {

  @Inject LoginService loginService
  @Inject PWHashingService pwHashing
  @Inject EventIds eventIds

  // ====================
  override verifyIdentity(
    String login,
    String password,
    Result<Boolean> res
  ) {
    // ====================
    log.info("verifyIdentity(...)")
    verifyInternal(
      login,
      password,
      defaultValueOnUncaughtError(res, false)
    );
  }

  def verifyInternal(
    String login, 
    String password, 
    Result<Boolean> result
  ) {
    loginService.findOneIdentity(login, 
      result.then[ identity, findRes |
        if(!identity.isPresent) {
          findRes.ok(false)
        } else {
          checkPassword(password, identity.get, findRes)
        }
      ]
    )
  }
  
  def checkPassword(
    String password, 
    Identity persistedIdentity,
    Result<Boolean> res
  ) {
    pwHashing.check(password, persistedIdentity.digest, 
      res.then[ success, checkRes |
        if(success) {
          eventIds.next(checkRes.then[ eventId |
            raiseClientAuthenticated(eventId, persistedIdentity.login)
            return true
          ])
        }
        else {
          checkRes.ok(false)
        }
      ]
    )
  }
  
  def raiseClientAuthenticated(long eventId, String login) {
    val clientAuthenticated = ClientAuthenticated.builder
      .id(eventId)
      .login(login)
      .timestamp(BarflakeDecoder.decodeTimestamp(eventId, 0L))
      .build
    log.info("{}", clientAuthenticated)              
  }

}
