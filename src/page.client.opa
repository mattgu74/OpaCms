/*
 * PAGE.CLIENT.OPA
 * @author Matthieu Guffroy
 *
 */

package OpaCms.page
import OpaCms.editor
import stdlib.web.client

@client Page_client = {{

  load(page : Page.t, menu : xhtml) =
    do Client.setTitle("[OpaCms] - {page.title}")
    do Dom.transform([#page_title <- page.title])
    do Dom.transform([#page_content <- <>{Xhtml.of_string_unsafe(page.content)}</>])
    do Dom.transform([#sidebar <- <>{menu}</>])
    do Dom.transform([#footer <- <> OpaCms - Author Matthieu Guffroy</>])
    void

  get() =
    title = Dom.get_content(#page_title)
    content = Editor.getContent(#page_content)
    (title, content)
    

  admin_interface(save, url, parent, data) =
    do Editor.add_toolbar() // add toolbar
    do Dom.transform([#toolbar -<- <span onclick={_ -> Dom.toggle(#tbar)}> [editor] </><span onclick={_ -> Dom.toggle(#tools)}> [params] </><br/>]) 
    do Dom.transform([#toolbar +<- <div id=#tools />])
    do editable(#page_title, save) // #title is editable
    do editable(#page_content, save) // #content is editable
    admin_tools(url, parent, data) // Add optional edit like url or page_parent

  editable(div : dom, fun) =
    Editor.addInstance(div, fun) // div is editable and save is the callback function

  admin_tools(url, parent, data) = 
    (a, b) = data
    do Dom.transform([#tools +<- a])
    do Dom.set_value(#admin_parent, b)
    do Editor.addInstance(#admin_url, url)
    do Editor.bind(#admin_parent, {change}, parent)
    void


  get_url() =
    Dom.get_value(#admin_url)

  get_parent() =
    Dom.get_value(#admin_parent)
    

}}
