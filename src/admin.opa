/*
 * ADMIN.OPA
 * @author Matthieu Guffroy
**/

package OpaCms.admin
import OpaCms.user
import OpaCms.page

Admin = {{

  home()=
    body = if User.is_logged() then
      <div>
        <div>
          <h1>Users</h1>
          {User.admin()}
        </div>
        <div>
          <h1>Website configuration</h1>
          {Config.admin()}
        </div>
        <div>
          <h1>Website theme</h1>
          {Theme.editor()}
        </div>
      </div>
    else
      <div id=#login_box>{User.loginbox()}</>
    Resource.styled_page("[OpaCms] - Admin", ["/_css_admin.css"], <h1>Administration</h1><>{body}</>)

  resource : Parser.general_parser(http_request -> resource) =
    parser
    | .* ->
      _req -> home()
}}


