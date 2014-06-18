class @UseCase
  #------------------------#
  #     INITIALIZATION     #
  #------------------------#
  @userGuid    = ''
  @authToken   = ''
  @currentUser = {}

  constructor: ->
    UseCase.userGuid  = Cookie.get('user_guid')
    UseCase.authToken = Cookie.get('auth_token')

  setDependency: (@serverSide, @securityManager, @guiAdapter) =>

  isUserLoggedIn: -> UseCase.userGuid and UseCase.authToken

  setCredentials: (data) =>
    UseCase.userGuid  = data.guid
    UseCase.authToken = data.token
    if @rememberMe
      Cookie.set('user_guid',  UseCase.userGuid)
      Cookie.set('auth_token', UseCase.authToken)

  resetCredentials: =>
    UseCase.userGuid = UseCase.authToken = undefined
    Cookie.remove 'user_guid'
    Cookie.remove 'auth_token'

  #------------------------#
  #      LOADING USER      #
  #------------------------#
  loadUserData: => @serverSide.loadUserData(@userLoaded, @userNotLoaded)

  userLoaded: (userJSON) =>
    UseCase.currentUser = new User userJSON
    @guiAdapter.userLoaded userJSON

  userNotLoaded: (errorCode, errorName) =>
    @guiAdapter.userNotLoaded errorCode, errorName

  #------------------------#
  #         LOGIN          #
  #------------------------#
  login: (email, password, @rememberMe) =>
    @securityManager.login(email, password, @userLoggedIn, @userNotLoggedIn)

  userLoggedIn: (data)  =>
    @setCredentials data
    @guiAdapter.userLoggedIn data

  userNotLoggedIn: (errorCode, errorName) =>
    @guiAdapter.userNotLoggedIn errorCode, errorName

  #------------------------#
  #        REGISTER        #
  #------------------------#
  register: (email, password, @rememberMe) =>
    @securityManager.register(email, password, @userRegistered, @userNotRegistered)

  userRegistered: (data) =>
    @setCredentials data
    @guiAdapter.userRegistered data

  userNotRegistered: (errorCode, errorName) =>
    @guiAdapter.userNotRegistered errorCode, errorName

  #------------------------#
  #     PASSWORD RESET     #
  #------------------------#
  resetPassword: (email) =>
    @securityManager.resetPassword(email, @passwordReseted, @passwordNotReseted)

  passwordReseted: =>
    @guiAdapter.passwordReseted()

  passwordNotReseted: (errorCode, errorName) =>
    @guiAdapter.passwordNotReseted errorCode, errorName

  #------------------------#
  #     PASSWORD CHANGE    #
  #------------------------#
  changePassword: (old_password, new_password) =>
    @securityManager.changePassword(old_password, new_password, @passwordChanged, @passwordNotChanged)

  passwordChanged: =>
    @guiAdapter.passwordChanged()

  passwordNotChanged: (errorCode, errorName) =>
    @guiAdapter.passwordNotChanged errorCode, errorName

  #------------------------#
  #      EMAIL CHANGE      #
  #------------------------#
  changeEmail: (new_email, password) =>
    @securityManager.changeEmail(new_email, password, @emailChanged, @emailNotChanged)

  emailChanged: =>
    @guiAdapter.emailChanged()

  emailNotChanged: (errorCode, errorName) =>
    @guiAdapter.emailNotChanged errorCode, errorName

  #------------------------#
  #     ACCOUNT DELETE     #
  #------------------------#
  deleteAccount: (password) =>
    @securityManager.deleteAccount(password, @accountDeleted, @accountNotDeleted)

  accountDeleted: =>
    @resetCredentials()
    @guiAdapter.accountDeleted()

  accountNotDeleted: (errorCode, errorName) =>
    @guiAdapter.accountNotDeleted errorCode, errorName

  #------------------------#
  #         LOGOUT         #
  #------------------------#
  logout: =>
    @securityManager.logout(@logoutSuccess, @logoutFailure)

  logoutSuccess: =>
    @resetCredentials()
    @guiAdapter.logoutSuccess()

  logoutFailure: (errorCode, errorName) =>
    @guiAdapter.logoutFailure errorCode, errorName