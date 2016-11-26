package wachtmeister.timeline;

import io.baratine.service.Result;
import io.baratine.service.Service;

@Service
public interface EventIds {
	
	public static final String CONF_KEY_DATACENTER_ID = "datacenter.id";
	
	void next(Result<Long> res);

}
