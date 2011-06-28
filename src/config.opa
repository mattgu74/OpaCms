/*
 * @author Matthieu Guffroy - Thomas Recouvreux
 *
 */

package OpaCms.page

type Config.t = 
{
    site_name : string;
    footer : string;
    theme : Theme.ref
}

db /conf : Config.t

Config = {{
    default = { site_name = "[OpaCms]"; footer = "This website is designed with [OpaCms]"; theme = "default" : Theme.ref } : Config.t

    save() =
        void

    get() = /conf
    
    set_theme(name : Theme.ref) = /conf/theme <- name

    admin() : xhtml = 
      <button onclick={_ -> /conf <- default }> Reload the default conf </button>
      <p> Under construction... </p>
}}
/*
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
      <p onclick={_ -> /config <- default_config }> Reload the default conf </p>
      <p> Under construction... </p>

}}

default_config : Page.config =
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


#header \{
     margin: 0;
     padding: 30px;
     text-align: left;
     color: red;
     font-size: 300%;
\}

#logo \{
     background: url(\"/resources/opa-logo.png\") no-repeat scroll 0 0 transparent;
     height: 41px;
     margin: 5px 0 15px;
     width: 100px;
\}

#page_wrap \{
 width: 90%;
 margin: auto;
 padding: 0;
\}

#page \{
    margin: 0;
    padding: 20px;
    margin-left: 250px;
    border-color: #E8EEFF;
    border-width: 3px;
    border-top-style:solid;
    border-right-style:solid;
\}

#page_title \{
     text-align: left;
\}

#page_content \{
     margin: 0;
     padding: 0;
\}

#sidebar \{
 margin: 0;
 padding: 10px;
 display: block;
 float: left;
 width: 200px;
 text-align: left;
 border-color: #E8EEFF;
 border-width: 3px;
 border-top-style:solid;
 border-right-style:solid;
\}


#footer \{
    text-align: center;
    clear: both;
    display: block;
    margin-top: 50px;
    background-color: #FFF;
\}

#toolbar \{
    position: fixed;
    top: 0;
    right: 0;
    z-index: 999;
    text-align: right;
\}

#toolbar \{
    float: right;
    clear: both;
\}

") }


init_config() =
    do /config <- default_config
    match ?/config with
    | {none} ->
        /config <- default_config
    | _ -> void
    end
*/

init_config2() = 
    match ?/conf with
    | {none} ->
        /conf <- Config.default
    | _ -> void
    end


//do init_config()
do init_config2()
