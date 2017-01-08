package wachtmeister.timeline

import de.oehme.xtend.contrib.logging.slf4j.Slf4j
import io.baratine.config.Config
import io.baratine.service.Result
import javax.inject.Inject
import org.eclipse.xtend.lib.annotations.ToString
import pollbus.idgen.barflake.BarflakeGenerator

@Slf4j @ToString
class EventIdsGeneratorService implements EventIds {
  
	@Inject
	new(Config conf) {
	  
	  _datacenterId = conf.get(CONF_KEY_DATACENTER_ID, Integer, 1)
	  _workerId  = 1 // TODO: can baratine workers be bound to a fixed id or might they be recreated?
	  _generator = new BarflakeGenerator(_datacenterId, _workerId)
	  
    log.info("new EventIds {} using: {}", this, conf)
    
	}
	
	private final int _datacenterId
	private final int _workerId
	private final BarflakeGenerator _generator
	
	
	override void next(Result<Long> res) {
		val v = _generator.next
		res.ok(v)
	}
	
	
}