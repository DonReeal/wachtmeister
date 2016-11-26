package wachtmeister.webapp.routes

import de.oehme.xtend.contrib.logging.slf4j.Slf4j
import io.baratine.service.Service
import io.baratine.web.Get
import io.baratine.web.RequestWeb
import wachtmeister.webapp.view.WachtmeisterViewBuilder

@Slf4j
@Service
class Home {

  @Get("/")
  def void getHome(RequestWeb req) {
    log.info("GET /")
    req.ok(new WachtmeisterViewBuilder("home.jade", req).build);
  }

}
