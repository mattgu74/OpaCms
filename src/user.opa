/*
 * USER.OPA
 * @author Matthieu Guffroy
**/

package OpaCms.user
import stdlib.widgets.loginbox
import stdlib.crypto
import stdlib.web.client
// DATA

@abstract type User.passwd = string
@abstract type User.ref = string

type User.t = 
  {
    nom : string
    prenom : string
    passwd : User.passwd
  }

type User.status = { logged : User.ref } / { unlogged }
type User.info = UserContext.t(User.status)
type User.map('a) = ordered_map(User.ref, 'a, String.order)

db /users : User.map(User.t)

User_data = {{
  mk_ref( login : string ) : User.ref =
    String.to_lower(login)

  ref_to_string( login : User.ref ) : string =
    login

  save( ref : User.ref, user : User.t ) : void =
    /users[ref] <- user

  get( ref : User.ref ) : option(User.t) =
    ?/users[ref]
}}


init_user()=
  match ?/users["admin"] with
    | {none} ->
        admin : User.t =
          { nom="Administrateur" ;
            prenom="" ;
            passwd = Crypto.Hash.md5("admin") }
        /users["admin"] <- admin
    | _ -> void

do init_user()

User = {{

  @private state = UserContext.make({ unlogged } : User.status)

  get_status() = 
    UserContext.execute((a -> a), state)

  is_logged() = 
    match get_status() with
     | { logged = _ } -> true
     | { unlogged } -> false

  login(login, passwd) =
    useref = User_data.mk_ref(login)
    user = User_data.get(useref)
    do match user with 
     | {some = u} -> if u.passwd == Crypto.Hash.md5(passwd) then
                       UserContext.change(( _ -> { logged = User_data.mk_ref(login) }), state)
     | _ -> void
    Client.reload()

  logout() =
    do UserContext.change(( _ -> { unlogged }), state)
    Client.reload()

  start() =
    Resource.html("User module", <h1>Module User</h1><div id=#login_box>{loginbox()}</>)

  edit() = 
    if User.is_logged() then
      Resource.html("User module", <h1>Module User</h1><>Under construction</>)
    else
      start()

  admin() = 
    if User.is_logged() then
      nom_id = Dom.fresh_id()
      prenom_id = Dom.fresh_id()
      ref = get_status()
      match ref with
         | {unlogged} -> <>Error...</>
         | {logged=r} -> user = Option.get(User_data.get(r))
      <p>
        Nom : <input id=#{nom_id} 
                           onchange={_ -> User_data.save(r, {user with nom = Dom.get_value(#{nom_id})})} 
                           value={user.nom} /><br />
        Prenom : <input id=#{prenom_id} 
                           onchange={_ -> User_data.save(r, {user with prenom = Dom.get_value(#{prenom_id})})}  
                        value={user.prenom} />
      </p>
    else
      loginbox()

  view(login : string) =
    match User_data.get(User_data.mk_ref(login)) with
     | { none } -> Resource.html("User module", <h1>Module User</h1><>Error, the user {login} does'nt exist</>)
     | { some = _ } -> Resource.html("User module", <h1>Module User</h1><>This the public profil of {login}, this page is under construction</>)

  loginbox() : xhtml =
    user_opt = 
       match get_status() with 
         | { logged = u } -> Option.some(<>{User_data.ref_to_string(u)} => <a onclick={_ -> logout()}>Logout</a></>)
         | _ -> Option.none
    WLoginbox.html(WLoginbox.default_config, "login_box", login, user_opt)

  resource : Parser.general_parser(http_request -> resource) =
    parser
    | "/edit" ->
      _req -> edit()
    | "/view/" login=(.*) ->
      _req -> view(Text.to_string(login))
    | .* ->
      _req -> start()
}}


