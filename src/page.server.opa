/*
 * PAGE.SERVER.OPA
 * @author Matthieu Guffroy
 *
 */

package OpaCms.page
import OpaCms.editor
import stdlib.web.client

type Page.conf = { url :string ; admin : {true : string} / {false} }

type message = { reload_url : string } / { move_from : string; move_to : string } / {change_menu}

room = Network.cloud("room"): Network.network(message)

@server Page_server(c : option(Page.conf)) = {{

  conf = Option.default({url="" ; admin = {false}}, c) 

  default_template =     
                   myPage = Page_data.get(Page_data.mk_ref(conf.url))
                   menu = Page_data.get_xhtml_menu(Page_data.mk_ref(conf.url))
                   load = match conf.admin with
                            | {true = _} ->
                                    { js = <>{Editor.load}</>;
                                      title = match myPage.title with
                                                | "" -> <>Titre vide</>
                                                | _ -> <>{myPage.title}</>
                                              end 
                                    }
                            | {false} ->
                                    { js = <></>; title = <></> }
                           end
                   <>{load.js}</>
                   <div id=#page_wrap onready={_ -> ready()}>
                          <div id=#page_header ><h1>{load.title}</h1></div>
                          <div id=#page_content >{Xhtml.of_string_unsafe(myPage.content)}</div>
                          <div id=#page_sidebar >{menu}</>
                          <div id=#page_footer> OpaCms - Author Matthieu Guffroy </div>
                   </div> 

  // on ready
  ready() =
    do Debug.jlog("Page_server : ready")
    do Network.add_callback(message_from_room, room)
    match conf.admin with
      | {true = u} -> Page_client.admin_interface(save, change_url, change_parent, admin_data())
      | {false} -> void

  refresh() =
    myPage = Page_data.get(Page_data.mk_ref(conf.url))
    menu = Page_data.get_xhtml_menu(Page_data.mk_ref(conf.url))
    Page_client.load(myPage, menu)

  change_parent() =    
    newparent = match Page_client.get_parent() with
                 | "none" -> {none}
                 | a -> {some = Page_data.mk_ref(a)}
    do Page_data.set_parent(Page_data.mk_ref(conf.url), newparent)
    Network.broadcast({change_menu}, room)

  change_url() =
    url = Page_client.get_url()
    do Page_data.move(Page_data.mk_ref(conf.url), Page_data.mk_ref(url))
    Network.broadcast({move_from = conf.url ; move_to = url}, room)

  save() =
    (title, content) = Page_client.get()
    save_in_db(title, content)

  save_in_db(title, content) =
    myPage = Page_data.get(Page_data.mk_ref(conf.url))
    do Debug.jlog("try to save")
    page = { myPage with title = title ; content = content }
    do Page_data.save(conf.url, page)
    Network.broadcast({reload_url = conf.url}, room)

  admin_data() =
    myPage = Page_data.get(Page_data.mk_ref(conf.url))
    func(k,v,a)=
        match Page_data.compare_ref(k, Page_data.mk_ref(conf.url)) with
         | {eq} -> a
         | _ -> <>{a}</><option value={k}>{v.title}</option>
    options = Map.fold( func, Page_data.getAll(), <option value="none">  </option>)
    (<>Url : <br/>
    <input id=#admin_url value={Page_data.mk_ref(conf.url)} /><br />
     Parent page : <br/>
    <select id=#admin_parent>{options}</select><br/></>
    , Option.default("none", myPage.parent_page))

  message_from_room(msg : message)=
    match msg with
     | {reload_url = url} -> match String.compare(url, conf.url)
                              | {eq} -> refresh()
                              | _ -> void // A page has just been edit, but i'm not on it
                             end
     | {~move_from ; ~move_to} -> match String.compare(move_from, conf.url)
                              | {eq} -> Client.goto(move_to)
                              | _ -> refresh() // A page has just move, but it's not my actual page, I must refresh the menu
                             end
     | {change_menu} -> refresh() // someone change the menu
     | _ -> Debug.jlog("message not understand")

}}
