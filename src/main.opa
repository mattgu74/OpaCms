/*
 * MAIN
 *
 */

package OpaCms.main
import OpaCms.page
import OpaCms.user

render_page(url : string) =
  status = User.get_status()
  admin = match status with
           | {logged = u} -> user = User_data.ref_to_string(u)
                             do Debug.jlog(user) 
                             {true = user}
           | {unlogged} -> {false}
  page = Page_server(Option.some({~url ; ~admin}))
  body = page.default_template
  title = Page_data.get(Page_data.mk_ref(url)).title
  Resource.styled_page("[OpaCms] - {title}", ["/resources/css.css"] ,body)

urls : Parser.general_parser(http_request -> resource) =
  parser
  | {Rule.debug_parse_string(s -> jlog("URL: {s}"))} Rule.fail -> error("")  
  | "/user" result={User.resource} -> _req ->
      result
  | "/resources/nicEdit.js" .* -> _req -> @static_resource("./resources/nicEdit.js")
  | url=(.*) -> _req ->
      render_page(Text.to_string(url))

server = Server.make(Resource.add_auto_server(@static_resource_directory("resources"), urls))
