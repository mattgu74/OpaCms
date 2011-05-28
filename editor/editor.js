
var myNiceEditor = null

##register init:  -> void
##args()
{
  bkLib.onDomLoaded(function() {
      myNiceEditor = new nicEditor({iconsPath : '/resources/nicEditorIcons.gif'}); 
  });
}

##register set_panel: string -> void
##args(a)
{
  bkLib.onDomLoaded(function() {
      myNiceEditor.setPanel(a); 
  });
}

##register add_instance: string -> void
##args(a)
{
  bkLib.onDomLoaded(function() {
      myNiceEditor.addInstance(a); 
  });
}

##register save_temp: string -> void
##args(a)
{
     document.getElementById('__temp__').value = nicEditors.findEditor(a).getContent();
}