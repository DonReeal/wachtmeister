package wachtmeister.logins.simple

import de.oehme.xtend.contrib.logging.slf4j.Slf4j
import java.util.Collections
import java.util.HashMap
import java.util.Map
import java.util.Set

@Slf4j
class UniqueIndex<KEY, VALUE> {
	
	Map<KEY, VALUE> values = new HashMap
	
	def Set<KEY> keySet() {
	  return Collections.unmodifiableSet(values.keySet)
	}
	
	def boolean contains(KEY k) {
		values.containsKey(k)
	}
	
	def VALUE get(KEY k) {
		values.get(k);
	}
	
	def void add(KEY k, VALUE v) throws ValueTakenException {
		if(values.containsKey(k)) 
			throw new ValueTakenException("Already exists")
		else
			values.put(k, v);
	}
	
	def void remove(KEY k) {
		val w = values.remove(k);
		if(w === null) {
			log.warn("Intended removal without effect. "
				+ "No matching value was present for key: {}", k);
		}
	}
	
}