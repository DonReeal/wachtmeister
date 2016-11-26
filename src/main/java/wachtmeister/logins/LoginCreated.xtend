package wachtmeister.logins

import de.oehme.xtend.contrib.Buildable
import org.eclipse.xtend.lib.annotations.Data
import wachtmeister.Event

@Data @Buildable
class LoginCreated implements Event {
	
	long id
	String login
	String digest
	String email

}
