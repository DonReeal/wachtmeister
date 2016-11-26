package wachtmeister.logins;

public interface LoginsReducerSync {

  LoginDt apply(LoginCreated event);

  LoginDt apply(PasswordChanged event);

}
