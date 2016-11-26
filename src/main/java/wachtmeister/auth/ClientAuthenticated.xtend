package wachtmeister.auth

import de.oehme.xtend.contrib.Buildable
import org.eclipse.xtend.lib.annotations.Data

@Data @Buildable
class ClientAuthenticated {
	
	long id
	String login
	long timestamp
	
}
