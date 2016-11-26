package wachtmeister.logins;

import java.util.Optional;

import io.baratine.service.Result;
import io.baratine.service.Service;
import wachtmeister.auth.Identity;

@Service
public interface LoginService {

  public void createLogin(String login, String password, String email, Result<String> result);

  public void changePassword(String login, String password, Result<Boolean> result);

  public void isLoginAvailable(String login, Result<Boolean> result);

  public void findOneIdentity(String login, Result<Optional<Identity>> result);
}
