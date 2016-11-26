package wachtmeister.auth;

import io.baratine.service.Result;

public interface Auth {
	
	void verifyIdentity(String username, String password, Result<Boolean> result);
	
}