/*
 * EDITOR.OPA
 * @author Matthieu Guffroy
 *
 */

/*
 This module use the wysiwyg editor NicEdit.js
*/

package OpaCms.editor
import stdlib.core.web.resource

Editor = {{
  base_url = Resource.base_url?""

  load = <script type="text/javascript" src="{base_url}/tinymce/jscripts/tiny_mce/tiny_mce.js"></script>

  @client init()=
     ((%% editor.init %%)())

  @client getContent(dom : string)=
     ((%% editor.getContent %%)(dom))

  tiny_mce = @static_resource_directory("tinymce")

}}

