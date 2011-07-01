
##register init:  -> void
##args()
{
    tinyMCE.init({
	mode: "textareas",
	theme: "advanced"
    });
}

##register getContent: string -> string
##args(a)
{
    return tinyMCE.get(a).getContent();
}