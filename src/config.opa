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

init_config() = 
    match ?/conf with
    | {none} ->
        /conf <- Config.default
    | _ -> void
    end

//do init_config()
do init_config()
