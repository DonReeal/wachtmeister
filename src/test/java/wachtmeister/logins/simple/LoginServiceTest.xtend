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
import wachtmeister.timeline.EventIdsGeneratorService

import static org.hamcrest.Matchers.*
import static org.junit.Assert.*

@Slf4j
@RunWith(RunnerBaratine)
@ServiceTest(EventIdsGeneratorService)
@ServiceTest(PlaintextPWVerifier)
@ServiceTest(SingleAssetLoginService)
class LoginServiceTest {
  
  
  @Inject @Service("/LoginService")
  var LoginServiceSync loginService
  
  
  @Test
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
    
    loginService.createLogin(
      "bob", 
      "password.initial",
      "irrelevant-email@address"
    )
    
    loginService.changePassword(
      "bob",
      "password.changed"
    )
    
    assertThat(
      loginService.findOneIdentity("bob").get.digest, 
      is("password.changed")
    )
    
  }
  
  
  static class PlaintextPWVerifier 
    implements PWHashingService {
    
    override check(String plaintext, String hashed, Result<Boolean> result) {
      result.ok(plaintext == hashed)
    }
    
    override hash(String password, Result<String> result) {
      result.ok(password)
    }
    
  }
  
}
