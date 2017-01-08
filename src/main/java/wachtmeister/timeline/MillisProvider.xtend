package wachtmeister.timeline

import java.time.Clock
import javax.inject.Inject
import pollbus.idgen.barflake.CurrentTimeMillisProvider

class MillisProvider implements CurrentTimeMillisProvider {

  Clock clock

  @Inject new(Clock clock) {
    this.clock = clock
  }

  override currentAppTime() {
    clock.millis
  }

}
