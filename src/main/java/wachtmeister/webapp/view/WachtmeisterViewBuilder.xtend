package wachtmeister.webapp.view

import io.baratine.web.View.ViewBuilder
import io.baratine.web.View
import io.baratine.web.RequestWeb
import wachtmeister.webapp.csrf.CSRFToken
import wachtmeister.webapp.Flash

/**
 * Decorator for baratines View/ViewBuilder API
 * that appends Flash and CSRFToken automatically when present in given req
 */
class WachtmeisterViewBuilder {

  val ViewBuilder vb
  val RequestWeb req

  new(String viewName, RequestWeb req) {
    this.vb = View.newView(viewName)
    this.req = req
  }

  def set(String key, String value) {
    vb.add(key, value)
    return this
  }

  def <X> set(X value) {
    vb.add(value)
    return this
  }

  def <X> get(Class<X> type) {
    return vb.get(type)
  }

  def build() {
    injectWachtmeisterFormValues()
    return this.vb as View
  }

  def injectWachtmeisterFormValues() {

    // Baratine BUG Workaround
    req.attribute(new Nothing);

    val csrf = req.attribute(CSRFToken)
    if (csrf != null) {
      vb.add(CSRFToken.FORM_NAME, csrf.csrfToken)
    }

    val flash = req.attribute(Flash)
    if (flash != null) {
      vb.add("flash.error", flash.error);
      vb.add("flash.notice", flash.notice);
    }

  }

  private static final class Nothing {}

}
