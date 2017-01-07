package wachtmeister.pwhash

import de.oehme.xtend.contrib.logging.slf4j.Slf4j
import io.baratine.config.Config
import io.baratine.service.Result
import javax.inject.Inject
import org.mindrot.jbcrypt.BCrypt

@Slf4j
class PWHashingBCrypt implements PWHashingService {

  // log_rounds the log2 of the number of rounds of hashing to apply 
  // - the work factor therefore increases as 2**log_rounds.
  int logRounds

  @Inject new(Config conf) {
    logRounds = conf.get("pwhash.log2rounds", Integer, 10)
  }

  override check(String plaintext, String hashed, Result<Boolean> result) {
    result.ok(BCrypt.checkpw(plaintext, hashed));
  }

  override hash(String password, Result<String> result) {
    val salt = BCrypt.gensalt(logRounds);
    result.ok(BCrypt.hashpw(password, salt));
  }

}
