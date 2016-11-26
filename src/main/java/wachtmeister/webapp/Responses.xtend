package wachtmeister.webapp

import io.baratine.service.Result
import io.baratine.service.ResultChain
import io.baratine.web.RequestWeb

class Responses {
	
	static def <T> Result<T> fulfill(RequestWeb req) {
		return ResultChain.then(req.then,
			[v | return v],
			[err, req2 |  WebErrors.toErr(err, req)]
		)
	}
	
}