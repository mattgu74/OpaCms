/*
 * PAGE.CSS.OPA
 * @author Matthieu Guffroy
 *
 */

package OpaCms.page

@server Page_css = {{

  // TODO : this function must create the css corresponding to the page
  get(url) = 
    Resource.build_css("")


  resource : Parser.general_parser(resource) =
    parser
    | "/" url=(.*) ".css" -> get(Text.to_string(url))
    | .* -> get("")
}}
