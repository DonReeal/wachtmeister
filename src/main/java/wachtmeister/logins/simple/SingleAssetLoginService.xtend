package wachtmeister.logins.simple

import de.oehme.xtend.contrib.logging.slf4j.Slf4j
import io.baratine.service.Modify
import io.baratine.service.Result
import io.baratine.service.Service
import io.baratine.vault.Asset
import java.util.HashSet
import java.util.Optional
import javax.inject.Inject
import org.eclipse.xtend.lib.annotations.Data
import wachtmeister.auth.Identity
import wachtmeister.logins.LoginAlreadyTakenException
import wachtmeister.logins.LoginCreated
import wachtmeister.logins.LoginDt
import wachtmeister.logins.LoginService
import wachtmeister.logins.PasswordChanged
import wachtmeister.pwhash.PWHashingService
import wachtmeister.timeline.EventIds

import static wachtmeister.Preconditions.*

/**
 * CommandHandler for LoginsStore
 */
@Asset
@Service("/LoginService")
@Slf4j
class SingleAssetLoginService extends Logins implements LoginService {

  transient PWHashingService _pwHashing  
  transient EventIds _eventIds  
  transient val _reservedLogins = new HashSet<String>

  @Inject
  new(PWHashingService pwHashing, EventIds eventIds) {
    _pwHashing = pwHashing
    _eventIds = eventIds
  }

  private def isLoginTaken(String login) {
    return _reservedLogins.contains(login) 
      || isLoginManaged(login)
  }

  @Modify
  // =================================
  override createLogin(
    String login, 
    String password,
    String email, 
    Result<String> result
  ) throws LoginAlreadyTakenException {
  // =================================
  
    requireNonEmpty(login)
    requireNonEmpty(password)
    requireNonEmpty(email)    
    
    if(isLoginTaken(login)) {
      throw new LoginAlreadyTakenException("Login already taken")
    }
    
    else {
      _reservedLogins.add(login)
      createInternal(login, password, email) [ id, err |
        // in all cases: cleanup the reserved login
        _reservedLogins.remove(login)
        if(err === null)
          result.ok(id)
        else
          result.fail(err)
      ]
    }
  }

  private def createInternal(
    String login, 
    String password, 
    String email, 
    Result<String> res
  ) {        
    _pwHashing.hash(password, res.then [ pwHash, hashRes |
      _eventIds.next(hashRes.then [ eventId |
        val loginCreated = LoginCreated.builder
          .id(eventId)
          .login(login)
          .digest(pwHash)
          .email(email)
          .build
        val dt = apply(loginCreated)
        return Long.toString(dt.id)
      ])
    ])
  }

  // =====================
  override changePassword(
    String login, 
    String password, 
    Result<Boolean> result
  ) { // =================
  
    requireNonEmpty(login)
    requireNonEmpty(password)  
    
    if(!isLoginManaged(login))
      throw new IllegalArgumentException('''Unknown login:«login»''')
    else
      _pwHashing.hash(password, result.then [ pwHash, r |
        _eventIds.next(result.then [ eventId |
          apply(PasswordChanged.builder
            .eventId(eventId)
            .login(login)
            .digest(pwHash)
            .build
          )
          return true
        ])
      ])
  }

  // ===========================================================
  override isLoginAvailable(String login, Result<Boolean> result) {
  // ===========================================================
  
    requireNonEmpty(login)    
    result.ok(!isLoginTaken(login))
  
  }
  
  override findOneIdentity(String login, Result<Optional<Identity>> result) {
    
    requireNonEmpty(login)
    
    val loginDt = getByLogin(login)
    
    val identity = 
      if(loginDt === null) null 
      else IdentityDt.ofLoginDt(loginDt)
    
    result.ok(Optional.ofNullable(identity))
  }
  
  /*
   * Inline implementing Auth-API contract here
   */
  @Data 
  private static final class IdentityDt implements Identity {
    
    String login
    String digest
    
    static def ofLoginDt(LoginDt loginDt) {
      return new IdentityDt(loginDt.username, loginDt.digest)
    }
    
  }
  
}
