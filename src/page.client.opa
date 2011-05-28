/*
 * PAGE.CLIENT.OPA
 * @author Matthieu Guffroy
 *
 */

package OpaCms.page
import OpaCms.editor

@client Page_client = {{

  load(page : Page.t, menu : xhtml) =
    do Debug.jlog("Page_client : load")
    do Dom.transform([#page_header <- <h1>{page.title}</h1>])
    do Dom.transform([#page_content <- <>{Xhtml.of_string_unsafe(page.content)}</>])
    do Dom.transform([#page_sidebar <- <>{menu}</>])
    do Dom.transform([#page_footer <- <> OpaCms - Author Matthieu Guffroy</>])
    void

  get() =
    do Debug.jlog("Page_client : get")
    title = Dom.get_content(#page_header)
    content = Editor.getContent(#page_content)
    (title, content)
    

  admin_interface(save, url, parent, data) =
    do Debug.jlog("Page_client : admin_interface")
    do Editor.add_toolbar() // add toolbar
    do editable(#page_header, save) // #page_header is editable
    do editable(#page_content, save) // #page_content is editable
    admin_tools(url, parent, data) // Add optional edit like url or page_parent

  editable(div : dom, fun) =
    do Debug.jlog("Page_client: editable")
    Editor.addInstance(div, fun) // div is editable and save is the callback function

  admin_tools(url, parent, data) = 
    (a, b) = data
    do Dom.transform([#tools +<- a])
    do Dom.set_value(#admin_parent, b)
    do Editor.addInstance(#admin_url, url)
    do Editor.bind(#admin_parent, {change}, parent)
    void


  get_url() =
    do Debug.jlog("Page_client : get_url")
    Dom.get_value(#admin_url)

  get_parent() =
    do Debug.jlog("Page_client : get_parent")
    Dom.get_value(#admin_parent)
    

}}
