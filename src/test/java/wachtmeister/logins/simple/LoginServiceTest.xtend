package wachtmeister.logins.simple

import com.caucho.junit.RunnerBaratine
import com.caucho.junit.ServiceTest
import de.oehme.xtend.contrib.logging.slf4j.Slf4j
import io.baratine.service.Result
import io.baratine.service.Service
import javax.inject.Inject
import org.junit.Test
import org.junit.runner.RunWith
import wachtmeister.pwhash.PWHashingService

import static org.hamcrest.Matchers.*
import static org.junit.Assert.*
import wachtmeister.timeline.EventIds
import org.junit.Ignore

@Slf4j
@RunWith(RunnerBaratine)
@ServiceTest(PlaintextPWVerifier)
@ServiceTest(EventIdsIncrementingMock)
@ServiceTest(SingleAssetLoginService)
class LoginServiceTest {
  
  @Inject @Service("/LoginService")
  var LoginServiceSync loginService
  
  @Test @Ignore("currently fails when run after testcase below cause loginService is shared by other test in this class (baratine bug?)")
  def void createdLoginsAreNotAvailable() {
    
    loginService.createLogin(
      "alice:login", 
      "alice:password", 
      "alice:email"
    )
    
    assertThat(
      loginService.isLoginAvailable("alice:login"), 
      is(false)
    )
  }
  
  @Test
  def void passwordChanged() {
    
    val username = "changer:login";
    
    loginService.createLogin(
      username, 
      "initial", 
      "irrelevant"
    )
    
    val intitial = loginService.findOneIdentity(username)
    assertThat(intitial.isPresent, is(true))
    assertThat(intitial.get.digest, is("initial"))
    
    loginService.changePassword(username, "new")
    val then = loginService.findOneIdentity(username)
    assertThat(then.isPresent, is(true))
    assertThat(then.get.digest, is("new"))
    
  }
  
  // MOCK
  
  
  static final class PlaintextPWVerifier 
    implements PWHashingService {
    
    override check(String plaintext, String hashed, Result<Boolean> result) {
      log.info("{}@{} checking ...", 
        this.class.simpleName,
        this.hashCode
      )
      result.ok(plaintext == hashed)
    }
    override hash(String password, Result<String> result) {
      log.info("{}@{} hashing...", 
        this.class.simpleName,
        this.hashCode)
      result.ok(password)
    }
    
  }
  
  static final class EventIdsIncrementingMock 
    implements EventIds {
    
    var i = 0L    
    
    override next(Result<Long> res) {
      i++;
      log.info("{}@{} returning {}", 
        this.class.simpleName,
        this.hashCode, 
        i
      )
      res.ok(i)
    }
        
 }
  
}