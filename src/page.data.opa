/*
 * DATA.OPA
 * @author Matthieu Guffroy
 */

/*
 This module handle page data
*/

package OpaCms.page
import stdlib.core.web.resource

@abstract type Page.ref = string

type Page.t = {
    title : string ;
    resume : string ;
    url : string ;
    parent_page : option(Page.ref) ;
    sub_page : list(Page.ref) ;
    content : string ;
}

type Page.map('a) = ordered_map(Page.ref, 'a, String.order)
db /pages : Page.map(Page.t)

Page_data = {{

 base_url = Resource.base_url?""

 default_page = { title = "Error 404 - Page not found" ; 
               resume = "" ; 
               url="/404" ; 
               parent_page = Option.none ; 
               sub_page = [] ; 
               //content = Template.text("Page not found !") 
               content = "Page not found !" ;
               }

  empty_page = { 
    title = "" ;
    resume = "";
    url = "" ;
    parent_page = Option.none ;
    sub_page = [] ;
    content = "" ;
  }

  mk_ref( url : string ) : Page.ref =
    String.to_lower(url)

  compare_ref( a : Page.ref , b : Page.ref ) =
    String.compare(a,b)

  create( url : string ) : Page.t =
    page = { empty_page with title = "Titre" ; resume = "Resume" ; ~url ; content = "Cette page vient d'être créé." }
    do /pages[mk_ref(url)] <- page
    page

  save( url : string, page : Page.t ) : void =
    /pages[mk_ref(url)] <- page

  remove( url : string) : void = 
    Db.remove(@/pages[mk_ref(url)])

  get( page_ref : Page.ref ) : Page.t =
    Option.default(default_page ,?/pages[page_ref])

  /*get_config( page_ref ) =
    Option.default(default_page.config, ?/pages[page_ref]/config)*/



  /*
  Lister les pages sous forme d'une arborescence, avec un lien (page.url, page.title) vers chacune d'elles.
  <ul>
  <li>
        <a href="...">Titre</a>
        <ul>
                {sous pages}
        </ul>
  </li>
  ...
  </ul>
  */
  get_xhtml_menu( page_actuel : Page.ref) : xhtml =
    rec xhtml_menu( p_ref : Page.ref, acc : xhtml) : xhtml = 
        p = get(p_ref)
        submenu = match p.sub_page with
              | {nil} -> <></>
              | _ -> <ul>{List.fold(xhtml_menu, p.sub_page, <></>)}</ul>
              end
        <>{acc}
        <li>
                <a href="{base_url}{p.url}" >{p.title}</a>
                {submenu}
        </li></>
    pages = Map.To.val_list(/pages)
    pages = List.filter(p -> if p.parent_page == {none} then {true} else {false}, pages)
    pages = List.map(p -> mk_ref(p.url), pages)
    <>
    <ul>
            {List.fold(xhtml_menu, pages, <></>)}
    </ul>
    </>

  move( old : Page.ref, newurl : string ) =
    match ?/pages[old] with
     | {none} -> void // Exit because old page is not a page
     | {some = oldpage} ->
        newref = mk_ref(newurl)
        match ?/pages[newref] with
         | {some = _} -> void // Exit because next page exist
         | {none} ->
               newpage = { oldpage with url = newurl }
               do /pages[newref] <- newpage
               Db.remove(@/pages[old])
         end
      end

    getAll() =
      /pages

    set_parent(ref : Page.ref, parent) =
      page = get(ref)
      oldparent = page.parent_page
      do match oldparent with
       | {none} -> void
       | {some = pref} ->
         // Remove from the sublist of the old_parent
         test(r : Page.ref) = 
                match compare_ref(r,ref) with
                 | {eq} -> {true} : bool
                 | _ -> {false} : bool
         result =  List.remove_p(test, /pages[pref]/sub_page)
         /pages[pref]/sub_page <- result
      do match parent with
          | {none} -> void
          | {some = pref} ->
            // Add the ref to the subpage list of the new parent
            /pages[pref]/sub_page <- List.add(ref, /pages[pref]/sub_page)
      /pages[ref]/parent_page <- parent

    clean_child(ref : Page.ref) =
      sub_page = /pages[ref]/sub_page
      func(ref, acc)=
        sub = ?/pages[ref]
        if Option.is_none(sub) then
          acc
        else
          List.add(ref, acc)
      new_sub = List.fold(func,sub_page,[])
      /pages[ref]/sub_page <- new_sub
}}

// Could be removed in the future, but now we must clean the old db... (like the opacmsdemo :) )
do  List.fold((key, _ -> Page_data.clean_child(key)),Map.To.key_list(/pages), void)
