/*
 * EDITOR.OPA
 * @author Matthieu Guffroy
 *
 */

/*
 This module use the wysiwyg editor NicEdit.js
*/

package OpaCms.editor

Editor = {{

  load = <script type="text/javascript" src="/resources/nicEdit.js"></script>

  @client init()=
     do Dom.transform([#Body +<- <><textarea id=#__temp__ style="display:none;" /></>])
     ((%% editor.init %%)())

  @client setPanel(dom : dom)=
    ((%% editor.set_panel %%)(Dom.get_id(dom)))

  @client addInstance(dom : dom, func)=
    do ((%% editor.add_instance %%)(Dom.get_id(dom)))
    bind(dom, {blur}, func)

  @client bind(dom :dom, kind, func) : void=
    _ = Dom.bind(dom, kind, (_ -> func()))
    void

  @client getContent(dom : dom) =
    do ((%% editor.save_temp %%)(Dom.get_id(dom)))
    Dom.get_content(#__temp__)

  @client add_toolbar() =
    do init()
    do Dom.transform([#Body +<- <div id=#toolbar ><div id=#tbar /> </div>])
    setPanel(#tbar)

}}

