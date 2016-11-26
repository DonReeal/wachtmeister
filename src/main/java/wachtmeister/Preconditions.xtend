package wachtmeister

import java.util.Collection
import java.util.function.Function
import wachtmeister.logins.simple.ValueTakenException

class Preconditions {

  def static <T> requireAbsence(T value, Collection<T> c) {
    if(c.contains(value))
      throw new ValueTakenException('''Value:«value» already taken!''')
    return value
  }

  def static <T> requireThat(T t, Function<T, Boolean> func, String errMsg) {
    if(func.apply(t)) {
      return t
    }
    throw new IllegalArgumentException(errMsg)
  }

  def static void requireThat(boolean condition, String errMsg) {
    if(!condition) {
      throw new IllegalArgumentException(errMsg)
    }
  }

  def static <T> requireNotNull(T t) {
    requireNotNull(t, "Null not allowed!")
  }

  def static <T> requireNotNull(T t, String errMsg) {
    if(t === null) {
      throw new IllegalArgumentException(errMsg)
    }
    return t
  }

  def static requireNonEmpty(String s) {
    requireNonEmpty(s, "Only non empty Strings supported!")
  }

  def static requireNonEmpty(String s, String errMsg) {
    if(Strings.isEmpty(s))
      throw new IllegalArgumentException(errMsg)
    return s
  }

}
