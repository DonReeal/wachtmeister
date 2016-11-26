package wachtmeister.timeline

import de.oehme.xtend.contrib.Buildable
import java.time.LocalDateTime
import java.time.ZoneOffset
import org.eclipse.xtend.lib.annotations.Data
import pollbus.idgen.barflake.BarflakeDecoder

class BarflakeUtil {

  def static String prettyPrintXtendLikeFormatting(long rawBarflakeValue) {

    val unixMillis = BarflakeDecoder.decodeTimestamp(rawBarflakeValue, 1456530296738L)
    val unixSeconds = unixMillis / 1_000
    val nanos = (unixMillis % 1_000) as int * 1_000_000

    '''
      [
          raw: «rawBarflakeValue»
          timestamp: «LocalDateTime.ofEpochSecond(unixSeconds, nanos, ZoneOffset.UTC)»
          sequence: «BarflakeDecoder.decodeSequence(rawBarflakeValue)»
          datacenter: «BarflakeDecoder.decodeDataCenter(rawBarflakeValue)»
          worker: «BarflakeDecoder.decodeWorker(rawBarflakeValue)»
        ]
    '''
  }

  def static BarflakeDecoded decode(long rawValue) {

    val unixMillis = BarflakeDecoder.decodeTimestamp(rawValue, 1456530296738L)
    val unixSeconds = unixMillis / 1_000
    val nanos = (unixMillis % 1_000) as int * 1_000_000

    (BarflakeUtil.BarflakeDecoded.builder => [
      timestamp = LocalDateTime.ofEpochSecond(unixSeconds, nanos, ZoneOffset.UTC)
      sequence = BarflakeDecoder.decodeSequence(rawValue)
      datacenter = BarflakeDecoder.decodeDataCenter(rawValue)
      worker = BarflakeDecoder.decodeWorker(rawValue)
    ]).build

  }

  @Data @Buildable
  public static class BarflakeDecoded {
    private LocalDateTime timestamp
    private int sequence
    private int datacenter
    private int worker
  }

}
