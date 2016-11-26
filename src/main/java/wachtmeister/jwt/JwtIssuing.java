package wachtmeister.jwt;

import io.baratine.service.Result;

public interface JwtIssuing {

  void createJwt(String username, Result<String> result);

  void verifiedGet(String jwts, Result<String> result);

}
