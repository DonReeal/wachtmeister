package wachtmeister.webapp.routes

import de.oehme.xtend.contrib.Buildable
import org.eclipse.xtend.lib.annotations.Data
import org.eclipse.xtext.xbase.lib.util.ToStringBuilder

@Data @Buildable
class LoginAttemptData {
  
  static val PASSWORD_MASK = "*****"
  
  val String username
  val String password
  val String csrfToken
  val String clienIpAdress
  
  override toString() {
    new ToStringBuilder(this)
      .add("username", username)
      .add("password", PASSWORD_MASK)
      .add("csrfToken", csrfToken)
      .add("clientIpAdress", clienIpAdress)
      .toString
  }
  
}