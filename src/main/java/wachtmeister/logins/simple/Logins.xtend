package wachtmeister.logins.simple

import de.oehme.xtend.contrib.logging.slf4j.Slf4j
import java.util.HashMap
import java.util.Optional
import pollbus.idgen.barflake.BarflakeDecoder
import wachtmeister.logins.LoginCreated
import wachtmeister.logins.LoginDt
import wachtmeister.logins.LoginsReducerSync
import wachtmeister.logins.PasswordChanged

import static wachtmeister.Preconditions.*

@Slf4j
public class Logins implements LoginsReducerSync {


  val managedLoginValues = new HashMap<Long, LoginDt>
  val uniqueLoginIndex = new UniqueIndex<String, Long>

  def getById(long id) {
    Optional.ofNullable(managedLoginValues.get(id))
  }
  
  def isLoginManaged(String login) {
    uniqueLoginIndex.get(login) !== null
  }
  
  def LoginDt getByLogin(String login) {
    
    val id = uniqueLoginIndex.get(login) 
    
    return
      if(id == null) null 
      else managedLoginValues.get(id)
  
  }

  override apply(LoginCreated loginCreated) {
    
    requireAbsence(loginCreated.id, managedLoginValues.keySet)
    requireAbsence(loginCreated.login, uniqueLoginIndex.keySet)
    
    val login = new LoginDt => [
      id = loginCreated.id
      created = loginCreated.id
      revision = loginCreated.id
      email = loginCreated.email
      username = loginCreated.login
      digest = loginCreated.digest
    ]
    
    managedLoginValues.put(login.id, login)
    uniqueLoginIndex.add(login.username, login.id)
    
    log.info("applied: {}", loginCreated)
    
    return login
  }

  override apply(PasswordChanged pwChanged) {
      
    val username = pwChanged.login
    
    requireThat(username, [isLoginManaged(it)],'''
      Trying to changed password for unmanaged login:«username»
    ''')
    
    val login = getByLogin(username)
    login.digest = pwChanged.digest
    login.passwordChangeDate = BarflakeDecoder.decodeTimestamp(pwChanged.eventId, 0L)
    
    return login
    
  }
  
}