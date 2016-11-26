package wachtmeister.logins

import de.oehme.xtend.contrib.Buildable
import org.eclipse.xtend.lib.annotations.Data

@Data @Buildable
class PasswordChanged {

  long eventId;
  String login;
  String digest;
  long passwordChangeDate;

  def static Builder of(LoginDt dt) {
    return new Builder => [
      login = dt.username
      digest = dt.digest
      passwordChangeDate = dt.passwordChangeDate
    ];
  }

}
