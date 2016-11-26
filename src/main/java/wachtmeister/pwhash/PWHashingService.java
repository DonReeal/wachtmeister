package wachtmeister.pwhash;

import io.baratine.service.Result;
import io.baratine.service.Service;
import io.baratine.service.Workers;

@Service
@Workers(10)
public interface PWHashingService {

	public void hash(String password, Result<String> result);
	
	public void check(String plaintext, String hashed, Result<Boolean> result);	
	
}