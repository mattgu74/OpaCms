/*
 * @author Matthieu Guffroy - Thomas Recouvreux
 *
 */

package OpaCms.page
import stdlib.core.xhtml

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
      site_name_id = Dom.fresh_id()
      footer_id = Dom.fresh_id()
      conf = get()
      reload() =
               do /conf <- default
               do Dom.set_value(#{site_name_id}, get().site_name)
               do Dom.set_value(#{footer_id}, get().footer)
               void
      <button onclick={_ -> reload() }> Reload the default conf </button>
      <p>
        Site name : <input id=#{site_name_id} 
                           onchange={_ -> /conf <- {get() with site_name = Dom.get_value(#{site_name_id})}} 
                           value={conf.site_name} /><br />
        Footer : <input id=#{footer_id} 
                        onchange={_ -> /conf <- {get() with footer = Dom.get_value(#{footer_id})}} 
                        value={conf.footer} />
      </p>
}}

init_config() = 
    match ?/conf with
    | {none} ->
        /conf <- Config.default
    | _ -> void
    end

//do init_config()
do init_config()
