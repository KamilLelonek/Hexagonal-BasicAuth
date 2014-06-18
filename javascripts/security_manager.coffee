class @SecurityManager extends Ajax

  login: (email, password, success, error) =>
    @doPost(
      url    : "#{@baseUrl}/login"
      action : 'login'
      data   :
        email    : email
        password : password
      success
      error
    )

  register: (email, password, success, error) =>
    @doCreate(
      url    : "#{@baseUrl}/register"
      action : 'register'
      data   :
        email    : email
        password : password
      success
      error
    )

  resetPassword: (email, success, error) =>
    @doPost(
      url    : "#{@baseUrl}/users/reset_password"
      action : 'resetPassword'
      data   :
        email   : email
      success
      error
    )

  changeEmail: (new_email, password, success, error) =>
    @doChange(
      url    : "#{@baseUrl}/users/#{UseCase.userGuid}/change_email"
      action : 'changeEmail'
      data   :
        new_email : new_email
        password  : password
      success
      error
    )

  changePassword: (old_password, new_password, success, error) =>
    @doChange(
      url    : "#{@baseUrl}/users/#{UseCase.userGuid}/change_password"
      action : 'changePassword'
      data   :
        old_password : old_password
        new_password : new_password
      success
      error
    )

  deleteAccount: (password, success, error) =>
    @doDelete(
      url    : "#{@baseUrl}/users/#{UseCase.userGuid}"
      action : 'deleteAccount'
      data   :
        password : password
      success
      error
    )

  logout: (success, error) =>
    @doDelete(
      url    : "#{@baseUrl}/logout/#{UseCase.userGuid}"
      action : 'logout'
      success
      error
    )