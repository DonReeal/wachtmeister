package wachtmeister.webapp

import de.oehme.xtend.contrib.logging.slf4j.Slf4j
import io.baratine.web.HttpStatus
import io.baratine.web.RequestWeb
import wachtmeister.logins.LoginAlreadyTakenException

@Slf4j
class WebErrors {
	
	static def void toError(LoginAlreadyTakenException ex, RequestWeb req) {
		webError(Error.builder
				.type(LoginAlreadyTakenException.simpleName)
				.httpStatusCode(HttpStatus.BAD_REQUEST.code)
				.message(ex.message)
				.build, 
			req)
	}
	
	static def void toError(Throwable t, RequestWeb req) {
		webError(Error.builder
						.httpStatusCode(HttpStatus.INTERNAL_SERVER_ERROR.code)
						.message("Something bad just happened. Sorry :'(. Error message was: " + t.message)
						.build,
					req)
	}
	
	static def void toErr(Throwable t, RequestWeb req) {
		
		if(t instanceof LoginAlreadyTakenException) {
			toError(LoginAlreadyTakenException.cast(t), req)
		}
		else {
			t.printStackTrace
			webError(Error.builder
						.httpStatusCode(HttpStatus.INTERNAL_SERVER_ERROR.code)
						.message("Something bad just happened. Sorry :'(! \"" + t.message + "\"")
						.build,
				req.status(HttpStatus.INTERNAL_SERVER_ERROR))
		}
	}
	
	static def void webError(Error err, RequestWeb req) {
		req.ok(err)
	}
	
}