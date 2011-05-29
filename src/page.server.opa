/*
 * PAGE.SERVER.OPA
 * @author Matthieu Guffroy
 *
 */

package OpaCms.page
import OpaCms.editor

type Page.conf = { url :string ; admin : {true : string} / {false} }

type message = { reload_url : string }

room = Network.cloud("room"): Network.network(message)

@server Page_server(c : option(Page.conf)) = {{

  conf = Option.default({url="" ; admin = {false}}, c) 

  default_template =     
                   myPage = Page_data.get(Page_data.mk_ref(conf.url))
                   menu = Page_data.get_xhtml_menu(Page_data.mk_ref(conf.url))
                   load = match conf.admin with
                            | {true = _} -> <>{Editor.load}</>
                            | {false} -> <></>
                           end
                     <>{load}</>
                     <div id=#page_wrap onready={_ -> ready()}>
                          <div id=#page_header ><h1>{myPage.title}</h1></div>
                          <div id=#page_content >{Xhtml.of_string_unsafe(myPage.content)}</div>
                          <div id=#page_sidebar >{menu}</>
                          <div id=#tools />
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
    refresh()

  change_url() =
    url = Page_client.get_url()
    do Page_data.move(Page_data.mk_ref(conf.url), Page_data.mk_ref(url))
    Client.goto(url)

  save() =
    (title, content) = Page_client.get()
    save_in_db(title, content)

  save_in_db(title, content) =
    myPage = Page_data.get(Page_data.mk_ref(conf.url))
    do Debug.jlog("try to save")
    page = { title = title ; 
             resume = myPage.resume ; 
             url = conf.url ; 
             parent_page = myPage.parent_page ; 
             sub_page = myPage.sub_page ; 
             content = content }
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
     | _ -> Debug.jlog("message not understand")

}}
