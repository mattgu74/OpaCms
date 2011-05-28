/*
 * MAIN
 *
 */

package OpaCms.main
import OpaCms.page
import mattgu74.cas // Use CAS authentification

cas_conf = {
  url = "https://cas.utc.fr/cas/" ; 
  service = "http://localhost:8080"
 } : Cas.config

myCas = Cas(cas_conf)

render_page(url : string) =
  status = myCas.get_status()
  admin = match status with
           | {logged = user} -> do Debug.jlog(user) 
                                {true = user}
           | {unlogged} -> {false}
  page = Page_server(Option.some({~url ; ~admin}))
  body = page.default_template
  title = Page_data.get(Page_data.mk_ref(url)).title
  Resource.styled_page("[OpaCms] - {title}", ["/resources/css.css"] ,body)

urls : Parser.general_parser(http_request -> resource) =
  parser
  | {Rule.debug_parse_string(s -> jlog("URL: {s}"))} Rule.fail -> error("")  
  | result={myCas.resource} -> _req ->
      result
  | "/resources/nicEdit.js" .* -> _req -> @static_resource("./resources/nicEdit.js")
  | url=(.*) -> _req ->
      render_page(Text.to_string(url))

server = Server.make(Resource.add_auto_server(@static_resource_directory("resources"), urls))
