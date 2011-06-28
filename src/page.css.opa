/*
 * PAGE.CSS.OPA
 * @author Matthieu Guffroy
 *
 */

package OpaCms.page

/*type Page_css.propertie = { rule : string ; param : string }
type Page_css.properties = { apply_on : string ; prop : list(Page_css.propertie) }
type Page_css.style = list(Page_css.properties)*/
@abstract type Page_css.style = string


@server Page_css = {{

  empty = "" : Page_css.style

  to_string(style : Page_css.style) =
    /*propertie_to_string(p : Page_css.propertie) =
      "{p.rule} : {p.param};"  
    properties_to_string(p : Page_css.properties) =
      fun(v, a) =
        "{propertie_to_string(v)} {a}"
      "{p.apply_on} \{ {List.fold(fun, p.prop, "")} \}"
    fun(v, a) =
      "{properties_to_string(v)} {a}"
    List.fold(fun, style, "")*/
    style

  merge(global : option(Page_css.style), page : option(Page_css.style)) : Page_css.style =
    "{to_string(Option.default("", global))} {to_string(Option.default("", page))}"

  get(url) =
    Resource.build_css(to_string(Theme.get(Config.get().theme)))

  resource : Parser.general_parser(resource) =
    parser
    | "/" url=(.*) ".css" -> get(Text.to_string(url))
    | .* -> get("")
}}
