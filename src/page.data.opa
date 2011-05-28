/*
 * DATA.OPA
 * @author Matthieu Guffroy
 */

/*
 This module handle page data
*/

package OpaCms.page

@abstract type Page.ref = string

type Page.t = {
 title : string ;
 resume : string ;
 url : string ;
 parent_page : option(Page.ref) ;
 sub_page : list(Page.ref) ;
 content : string
}

type Page.map('a) = ordered_map(Page.ref, 'a, String.order)
db /pages : Page.map(Page.t)

Page_data = {{
 default_page = { title = "Error 404 - Page not found" ; 
               resume = "" ; 
               url="/404" ; 
               parent_page = {none} ; 
               sub_page = {nil} ; 
               //content = Template.text("Page not found !") 
               content = "Page not found !" 
               }


  mk_ref( url : string ) : Page.ref =
    String.to_lower(url)

  compare_ref( a : Page.ref , b : Page.ref ) =
    String.compare(a,b)

  create( url : string ) : Page.t =
    page = { title = "Titre" ; resume = "Resume" ; ~url ; parent_page = {none} ; sub_page = {nil} ; content = "Cette page vient d'être créé." }
    do /pages[mk_ref(url)] <- page
    page

  save( url : string, page : Page.t ) : void =
    /pages[mk_ref(url)] <- page

  get( page_ref : Page.ref ) : Page.t =
    Option.default(default_page ,?/pages[page_ref])

  submenu(value, acc) =
    page = get(value)
    func(a) = match a with
                    | {nil} -> <></>
                    | _ -> <ul>{List.fold(submenu, a, <></>)}</ul>
                   end
    <>{acc}<li><a href="{page.url}" >{page.title}</a>
                {func(page.sub_page)}
           </li></>

  menu(key, value, acc) =
    func(a) = match a with
                    | {nil} -> <></>
                    | _ -> <ul>{List.fold(submenu, a, <></>)}</ul>
    match value.parent_page with
      | {none} -> <>{acc}<li><a href="{value.url}" >{value.title}</a>
                  {func(value.sub_page)}
                         </li></>
      | _ -> acc

  get_xhtml_menu( page_actuel : Page.ref) : xhtml =
    <ul>{Map.fold(menu, /pages, <></>)}</ul>

  move( old : Page.ref, newurl : string ) =
    match ?/pages[old] with
     | {none} -> void // Exit because old page is not a page
     | {some = oldpage} ->
        newref = mk_ref(newurl)
        match ?/pages[newref] with
         | {some = _} -> void // Exit because next page exist
         | {none} ->
               newpage = {title = oldpage.title ; 
                 resume = oldpage.resume ; 
                 url= newurl ; 
                 parent_page = oldpage.parent_page ; 
                 sub_page = oldpage.sub_page ;  
                 content = oldpage.content }
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

      newpage = {title = page.title ; 
               resume = page.resume ; 
               url= page.url ; 
               parent_page = parent ; 
               sub_page = page.sub_page ;  
               content = page.content }
      /pages[ref] <- newpage
}}

