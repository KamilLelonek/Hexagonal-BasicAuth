class @Ajax
  constructor: ->
    @baseUrl = "http://localhost:3000"

  doGet    : (requestData, success, error) => doAjax "GET",    requestData, success, error
  doPost   : (requestData, success, error) => doAjax "POST",   requestData, success, error
  doCreate : (requestData, success, error) => doAjax "POST",   requestData, success, error
  doChange : (requestData, success, error) => doAjax "POST",   requestData, success, error
  doDelete : (requestData, success, error) => doAjax "DELETE", requestData, success, error

  doAjax = (method, requestData, success, error) =>
    requestMethod =
      type      : method
      headers   :
        'X-Auth-Token' : UseCase.authToken
      xhrFields :
        withCredentials : true
      success   :                         (data) -> success(data)                  || console.log "#{this.action} successful"
      error     : (jqXHR, textStatus, errorName) -> error(jqXHR.status, errorName) || console.log "#{this.action} failed"

    $.ajax $.extend({}, requestMethod, requestData)

class @ServerSide extends Ajax

  inviteFriend: (friendEmail, success, error) =>
    @doPost(
      url    : "#{@baseUrl}/users/invite"
      action : 'inviteFriend'
      data   :
        friend_email : friendEmail
      success
      error
    )

  loadUserData: (success, error) =>
    @doGet(
      url    : "#{@baseUrl}/users/#{UseCase.userGuid}"
      action : 'loadUserData'
      success
      error
    )