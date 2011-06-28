/*
 * (c) Valdabondance.com - 2011
 * @author Matthieu Guffroy - Thomas Recouvreux
 *
 */

package OpaCms.page


type Theme.ref = string
type Theme.t = string

type Theme.map('a) = ordered_map(Theme.ref, 'a, String.order)
db /themes : Theme.map(Theme.t)


Theme = {{
    
    save(name : Theme.ref, theme : Theme.t) =
        do Debug.jlog("try to save theme {name}")
        if name != "default" : Theme.ref then
            /themes[name] <- theme
        else
            Debug.jlog("default ne peut pas être modifié")

    get(name : Theme.ref) = 
        /themes[name]

    editor() : xhtml =
        <div onready={_->init_editor()}>
        <select id=#theme_editor_select onchange={_-> set_editor(Dom.get_value(#theme_editor_select))}>
        {Map.fold(k,v,a -> <>{a}<option>{k}</option></>, /themes, <></>)}
        </select>
        <br/>
        <input id=#theme_editor_name type="text" /><br/>
        <textarea id=#theme_editor_content onblur={_->save(Dom.get_value(#theme_editor_name), Dom.get_value(#theme_editor_content))}></textarea>
        </div>
    
    init_editor() =
        set_editor(Config.get().theme)
    
    set_editor(name : Theme.ref) =
        current_theme = get(name)
        do Config.set_theme(name)
        do Dom.set_value(#theme_editor_select, name)
        do Dom.set_value(#theme_editor_name, name)
        Dom.set_value(#theme_editor_content, current_theme)
}}

default_theme = 
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
     margin-top: 0;
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

#theme_editor_content \{
    width: 100%;
    height: 200px;
\}
"

init_themes() = 
    /themes["default"] <- default_theme

do init_themes()

