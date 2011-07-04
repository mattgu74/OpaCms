/*
 * MAIN
 *
 */

import OpaCms.page
import OpaCms.user
import OpaCms.admin
import OpaCms.editor
import stdlib.core.web.resource
import stdlib.core

base_url = Resource.base_url?""

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
  Resource.styled_page("{Config.get().site_name} - {title}", ["{base_url}/_css_{url}.css"] ,body)

ga_js = 
"
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-5768473-3']);
  _gaq.push(['_trackPageview']);

  (function() \{
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
"

urls : Parser.general_parser(http_request -> resource) =
  parser
  | {Rule.debug_parse_string(s -> Log.notice("URL",s))} Rule.fail -> error("")  
  | "/user" result={User.resource} -> result
  | "/admin" result={Admin.resource} -> result
  | "/_css_" result={Page_css.resource} -> _req -> result
  | "/google_analytics.js" -> _req -> Resource.raw_text(ga_js)
  | url=(.*) -> 
    _req -> render_page(Text.to_string(url))


do Resource.register_external_js("/google_analytics.js")
server = Server.make(Resource.add_auto_server(Editor.tiny_mce, urls))
