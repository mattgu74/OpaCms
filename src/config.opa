/*
 * @author Matthieu Guffroy - Thomas Recouvreux
 *
 */

@abstract type Config.ref = String

type Config.t =
{
    style : String;
}


type Config.map('a) = ordered_map(Config.ref, 'a, String.order)

/configs = Config.map(Config.t)
/configs[_] = { style = "" }


Config = {{
    
    save() = 
           void


}}




init_config() = 
    match ?/configs["default"] with
    | {none} ->
        config : Config.t =
          { style = 
"
body {
    margin: 0;
    padding: 0;
    line-height: 1.4em;
}

a, a:link, a:visited {
    color: #0B67B2;
    text-decoration: none;
}

a:hover {
     color: #0B4D86;
     text-decoration: underline;
}

a:active {
    color: #B30A0A;
}

ul {
    margin: 0;
    padding: 0;
    list-style-position: inside;
}

li {
    list-style-type: disc;
    margin: 0;
    padding: 0;
}

ul li ul, ol li ol {
    margin-left: 20px;
}



pre {
     background: none repeat scroll 0% 0% #FFFFFF;
     border-color: #C6C6C2;
     border-style: solid;
     border-width: 1px 1px 1px 5px;
     color: #767672;
     margin: 5px 0;
     padding: 3px;
}

.button, input[type=submit] {
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
}
.button {float:left}

input#entry {
     float: left;
     margin: 5px;
     padding: 3px;
     width: 450px;
}
/***Header***/
#header {
     margin: 0;
     padding: 10px;
     position: relative;
     text-align: left;
}
"
        /configs["default"] <- config
    | _ -> void
    end

do init_config()
