/*
 * @author Matthieu Guffroy - Thomas Recouvreux
 *
 */

package OpaCms.page

type Page.config =
{
    title : option(string);
    footer : option(string);
    style : option(Page_css.style);
}

// The global config
db /config : Page.config

Page_config = {{
    
    empty = { title = Option.none ; footer = Option.none ; style = Option.none } : Page.config

    save() = 
           void

    get_default() : Page.config = 
        /config

    get(url) : Page.config =
      pagec = Page_data.get_config(Page_data.mk_ref(url))
      globalc = get_default()
      get_value(glob, page)=
        value=Option.default(Option.default("",glob),page) ;
        Option.some(value)
      { title = get_value(globalc.title,pagec.title) ;
        footer = get_value(globalc.footer,pagec.footer) ;
        style = Option.some(Page_css.merge(globalc.style,pagec.style)) ;
      }

    admin() =
      <p> Under construction... </p>

}}




init_config() = 
    match ?/config with
    | {none} ->
        config : Page.config =
          { title = Option.some("[OpaCms] - ");
            footer = Option.some("This website is designed with [OpaCms]");
style = Option.some( 
"
body \{
    margin: 0;
    padding: 0;
    line-height: 1.4em;
\}

a, a:link, a:visited \{
    color: #0B67B2;
    text-decoration: none;
\}

a:hover \{
     color: #0B4D86;
     text-decoration: underline;
\}

a:active \{
    color: #B30A0A;
\}

ul \{
    margin: 0;
    padding: 0;
    list-style-position: inside;
\}

li \{
    list-style-type: disc;
    margin: 0;
    padding: 0;
\}

ul li ul, ol li ol \{
    margin-left: 20px;
\}



pre \{
     background: none repeat scroll 0% 0% #FFFFFF;
     border-color: #C6C6C2;
     border-style: solid;
     border-width: 1px 1px 1px 5px;
     color: #767672;
     margin: 5px 0;
     padding: 3px;
\}

.button, input[type=submit] \{
  background: #B30A0A;
  border:0;
  text-align:center;
  color:white;
  border-radius: 0.3em 0.3em 0.3em 0.3em;
  -webkit-border-radius: 0.3em 0.3em 0.3em 0.3em;
  -moz-border-radius: 0.3em 0.3em 0.3em 0.3em;
  text-shadow: 0 1px 0 #777777;
  margin:5px 0;
  padding:2px 5px;
\}
.button \{float:left\}

input#entry \{
     float: left;
     margin: 5px;
     padding: 3px;
     width: 450px;
\}

#header \{
     margin: 0;
     padding: 10px;
     position: relative;
     text-align: left;
\}
") }
        /config <- config
    | _ -> void
    end

do init_config()
