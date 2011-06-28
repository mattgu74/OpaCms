/*
 * MAIN
 *
 */

import OpaCms.page
import OpaCms.user
import OpaCms.admin
import stdlib.core.web.server
import stdlib.core

base_url = Server_private.base_url

render_page(url : string) =
  status = User.get_status()
  admin = match status with
           | {logged = u} -> user = User_data.ref_to_string(u)
                             do Log.info("admin access", user) 
                             {true = user}
           | {unlogged} -> {false}
  page = Page_server(Option.some({~url ; ~admin}))
  body = page.default_template
  title = Page_data.get(Page_data.mk_ref(url)).title
  // There is two css file (the first is the general css file (static))
  // The second is created dynamically with the database
  Resource.styled_page("{Config.get().site_name} - {title}", ["/_css_{url}.css"] ,body)

urls : Parser.general_parser(http_request -> resource) =
  parser
  | {Rule.debug_parse_string(s -> Log.notice("URL",s))} Rule.fail -> error("")  
  | "/user" result={User.resource} -> result
  | "/admin" result={Admin.resource} -> result
  | "/resources/nicEdit.js" .* -> 
    _req -> @static_resource("./resources/nicEdit.js")
  | "/_css_" result={Page_css.resource} -> _req -> result
  | url=(.*) -> 
    _req -> render_page(Text.to_string(url))

server = Server.make(Resource.add_auto_server(@static_resource_directory("resources"), urls))
