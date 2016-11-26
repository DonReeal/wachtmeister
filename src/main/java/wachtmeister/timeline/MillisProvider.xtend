package wachtmeister.timeline

import pollbus.idgen.barflake.CurrentTimeMillisProvider
import java.time.Clock
import javax.inject.Inject

class MillisProvider implements CurrentTimeMillisProvider {

  Clock clock

  @Inject new(Clock clock) {
    this.clock = clock
  }

  override currentAppTime() {
    clock.millis
  }

}
