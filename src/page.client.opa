/*
 * PAGE.CLIENT.OPA
 * @author Matthieu Guffroy
 *
 */

package OpaCms.page
import OpaCms.editor

@client Page_client = {{

  load(page : Page.t, menu : xhtml) =
    do Client.setTitle("[OpaCms] - {page.title}")
    do Dom.transform([#page_header <- <h1>{page.title}</h1>])
    do Dom.transform([#page_content <- <>{Xhtml.of_string_unsafe(page.content)}</>])
    do Dom.transform([#page_sidebar <- <>{menu}</>])
    do Dom.transform([#page_footer <- <> OpaCms - Author Matthieu Guffroy</>])
    void

  get() =
    title = Dom.get_content(#page_header)
    content = Editor.getContent(#page_content)
    (title, content)
    

  admin_interface(save, url, parent, data) =
    do Editor.add_toolbar() // add toolbar
    do editable(#page_header, save) // #page_header is editable
    do editable(#page_content, save) // #page_content is editable
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
