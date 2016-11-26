package wachtmeister.service

import de.oehme.xtend.contrib.logging.slf4j.Slf4j
import io.baratine.service.Result
import io.baratine.service.ResultChain

/**
 * Utils for Chaining Baratine Async APIs (Result based invocations)
 */
@Slf4j
class ServiceInvocations {
  
  /** Suppress delegation of any exception and return a default value instead */
  static def <T> Result<T> defaultValueOnUncaughtError(Result<T> result, T valueOnError) {
    ResultChain.then(
      result,
      [ v |return v ],
      [ err, res |
        log.error("Unknown error processing AuthImpl#verifiyIdentity! Message was: {}", err.message)
        err.printStackTrace
        res.ok(valueOnError)
      ]
    );
  }
  
  
}
