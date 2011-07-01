/*
 * PAGE.CLIENT.OPA
 * @author Matthieu Guffroy
 *
 */

package OpaCms.page
import OpaCms.editor
import stdlib.web.client

@client Page_client = {{

  load(page : Page.t, menu : xhtml, config) =
    do Client.setTitle("{config.site_name} - {page.title}")
    do Dom.transform([#page_title <- page.title])
    do Dom.transform([#page_content <- <>{Xhtml.of_string_unsafe(page.content)}</>])
    do Dom.transform([#sidebar <- menu])
    do Dom.transform([#footer <- config.footer])
    void

  admin_interface(url, parent, data) =
    do Dom.transform([#Body +<- <div id=#toolbar ><div id=#tbar /> </div>])
    do Dom.transform([#toolbar -<- <span onclick={_ -> Dom.toggle(#tools)}> [params] </><br/>]) 
    do Dom.transform([#toolbar +<- <div id=#tools />])
    admin_tools(url, parent, data) // Add optional edit like url or page_parent

  edit() =
    //Hide the view
    do Dom.hide(#page_title)
    do Dom.hide(#page_content)
    do Dom.show(#Edit)
    void

  init_edit(page, save_in_db)=
    save()=
      get() =
        title = Dom.get_value(#edit_page_title)
        content = Editor.getContent("edit_page_content")
        (title, content)
      (title, content) = get()
      save_in_db(title, content)
    hide()=
      do Dom.hide(#Edit)
      do Dom.show(#page_title)
      do Dom.show(#page_content)
      void
    //title    
    do hide()
    do Dom.transform([#Edit <- <>Title : <input id=#edit_page_title onchange={_ -> save()} value={page.title} /></>])
    //content
    do Dom.transform([#Edit +<- <><textarea id=#edit_page_content >{Xhtml.of_string(page.content)}</textarea></>])
    do Dom.transform([#Edit +<- <><br/><button onclick={_ -> save()}>Save</button><button onclick={_ -> hide()}>Exit editing mode</button></> ])
    Editor.init()

  admin_tools(url, parent, data) = 
    (a, b) = data
    do Dom.transform([#tools +<- a])
    do Dom.set_value(#admin_parent, b)
    do ignore(Dom.bind(#admin_url, {blur}, (_ -> url()) ))
    do ignore(Dom.bind(#admin_parent, {change}, (_ -> parent()) ))
    void


  get_url() =
    Dom.get_value(#admin_url)

  get_parent() =
    Dom.get_value(#admin_parent)
    

}}
