/*
 * ADMIN.OPA
 * @author Matthieu Guffroy
**/

package OpaCms.admin
import OpaCms.user

Admin = {{

  home()=
    body = if User.is_logged() then
      <div>En construction...</div>
    else
      <div id=#login_box>{User.loginbox()}</>
    Resource.html("[OpaCms] - Admin", <h1>Administration</h1><>{body}</>)

  resource : Parser.general_parser(http_request -> resource) =
    parser
    | .* ->
      _req -> home()
}}


