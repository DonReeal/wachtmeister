package wachtmeister.webapp

import de.oehme.xtend.contrib.Buildable
import org.eclipse.xtend.lib.annotations.Data

@Data @Buildable
class Error {
	String type
	int httpStatusCode
	String message
}