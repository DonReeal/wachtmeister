package wachtmeister.logins.simple

import org.junit.Rule
import org.junit.Test
import org.junit.rules.ExpectedException
import wachtmeister.logins.LoginCreated

import static org.hamcrest.Matchers.*
import static org.junit.Assert.*

class LoginCreatedTest {
  
  var logins = new Logins()
  
  @Rule public var thrown = ExpectedException.none
    
  @Test
  def void loginCreatedDataAreMappedInDt() {
  	
  	val loginCreated = LoginCreated.builder
  	 .id(1L)
  	 .login("login")
  	 .digest("digest")
  	 .email("email")
  	 .build
  	 
  	val dt = logins.apply(loginCreated)
  	
    assertThat(loginCreated.id, is(dt.id))
  	assertThat(loginCreated.login, is(dt.username))
  	assertThat(loginCreated.digest, is(dt.digest))
  	assertThat(loginCreated.email, is(dt.email))  
  }

  @Test 
  def void createdLoginsCanBeFoundById() {
    
    val loginCreated = LoginCreated.builder
      .id(1L)
      .login("alice")
      .build
    logins.apply(loginCreated)
    
    assertTrue(logins.getById(1L).isPresent)
    assertTrue(logins.getById(1L).get.username === "alice")
  }
  
  @Test 
  def void createdLoginsCanBeFoundByLogin() {
  	
  	val alicesLogin = logins.apply(
      LoginCreated.builder
       .id(1L)
       .login("alice")
       .build  
    )
    
    assertThat(logins.getByLogin("alice"), is(alicesLogin))
  }
  
  @Test 
  def void createdLoginIsManaged() {
  	
  	logins.apply(
      LoginCreated.builder
       .id(1L)
       .login("alice")
       .build
    )
    
  	assertTrue(logins.isLoginManaged("alice"))
  }
  
  @Test
  def void alreadyManagedLoginsCannotBeCreated() {
  	
  	logins.apply(
      LoginCreated.builder
        .id(1L)
        .login("alice")
        .build
    )
    
    // trying to create already taken login should fail
    thrown.expect(ValueTakenException)
    logins.apply(
      LoginCreated.builder.id(2L)
       .login("alice").build
    )
  }
  
  @Test
  def void reapplyingLoginCreatedFails() {	
    
    var event = LoginCreated.builder
      .id(1L)
      .login("login")
      .build
    logins.apply(event)
    
    thrown.expect(ValueTakenException)    
    logins.apply(event)
  }
  
}
