package wachtmeister.logins.simple;

import java.util.Optional;

import wachtmeister.auth.Identity;

public interface LoginServiceSync {
	
	public String createLogin(String login, String password, String email);

	public boolean changePassword(String login, String password);

	public boolean isLoginAvailable(String login);
	
	public Optional<Identity> findOneIdentity(String login);

}
