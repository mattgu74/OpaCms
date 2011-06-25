/*
 * PAGE.CSS.OPA
 * @author Matthieu Guffroy
 *
 */

package OpaCms.page

type Page_css.propertie = { rule : string ; param : string }
type Page_css.properties = { apply_on : string ; prop : list(Page_css.propertie) }
type Page_css.style = list(Page_css.properties)

@server Page_css = {{

  to_string(style : Page_css.style) =
    propertie_to_string(p : Page_css.propertie) =
      "{p.rule} : {p.param};"  
    properties_to_string(p : Page_css.properties) =
      fun(v, a) =
        "{propertie_to_string(v)} {a}"
      "{p.apply_on} \{ {List.fold(fun, p.prop, "")} \}"
    fun(v, a) =
      "{properties_to_string(v)} {a}"
    List.fold(fun, style, "")

  get(url) = 
    style = Page_data.get_style(Page_data.mk_ref(url))
    Resource.build_css(to_string(style))

  resource : Parser.general_parser(resource) =
    parser
    | "/" url=(.*) ".css" -> get(Text.to_string(url))
    | .* -> get("")
}}
