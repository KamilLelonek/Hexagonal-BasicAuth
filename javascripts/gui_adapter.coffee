class @GuiAdapter
  #------------------------#
  #     INITIALIZATION     #
  #------------------------#
  setDependency: (@useCase) ->

  loadPage: =>
    @pageContent = $('main')
    if @useCase.isUserLoggedIn() then @loadUserData() else @loadForms()

  loadForms: (message) =>
    element = @compileElement 'form'
    @describeFormBehavior element, message
    @pageContent.replaceContent element

  describeFormBehavior: (element, message) =>
    element.find('#message').val(message) if message
    element.find('.form')           .on 'submit', (event) => event.preventDefault()
    element.find('#button-login')   .on 'click',          => @authenticate @login
    element.find('#button-register').on 'click',          => @authenticate @register
    element.find('#button-reset')   .on 'click',           => @resetPassword element.find('#email').val()

  authenticate: (method) =>
    @pageContent.find('#message').text ''
    email    = @pageContent.find('#email').val()
    password = @pageContent.find('#password').val()
    remember = @pageContent.find('#remember-me').is ':checked'
    method email, password, remember

  compileElement : (templateName, data = {}) =>
    $ Handlebars.templates[templateName](data)

  #------------------------#
  #      LOADING USER      #
  #------------------------#
  loadUserData: => @useCase.loadUserData()
  userLoaded: (data) =>
    element = @compileElement 'content', user: data
    element.find('#btn-logout')         .on 'click', @logout
    element.find('#btn-delete')         .on 'click', => @deleteAccount  element.find('#password').val()
    element.find('#btn-change-email')   .on 'click', => @changeEmail    element.find('#email')   .val(), element.find('#password').val()
    element.find('#btn-change-password').on 'click', => @changePassword element.find('#password').val(), element.find('#new-password').val()
    @pageContent.replaceContent element

  userNotLoaded: (errorCode, errorName) =>
    @loadForms("Login failure. Message was #{errorName}: #{errorCode}")
    @pageContent.find('.form')[0].reset()

  #------------------------#
  #         LOGIN          #
  #------------------------#
  login: (email, password, remember) => @useCase.login(email, password, remember)
  userLoggedIn: => @loadUserData()
  userNotLoggedIn: (errorCode, errorName) =>
    @pageContent.find('#message').text("Login failure. Message was #{errorName}: #{errorCode}")

  #------------------------#
  #        REGISTER        #
  #------------------------#
  register: (email, password, remember) => @useCase.register(email, password, remember)
  userRegistered: (data) => @loadUserData()
  userNotRegistered: (errorCode, errorName) =>
    @pageContent.find('#message').text("Register failure. Message was #{errorName}: #{errorCode}. Account with provided email alreaady exists or password not secure enough.")

  #------------------------#
  #     PASSWORD RESET     #
  #------------------------#
  resetPassword: (email) =>
    @useCase.resetPassword(email)
  passwordReseted: =>
    @pageContent.find('#message').text("Your new password has been send")
  passwordNotReseted: (errorCode, errorName) =>
    @pageContent.find('#message').text("Reseting password failure. Message was #{errorName}: #{errorCode}. Propably no such account.")

  #------------------------#
  #     PASSWORD CHANGE    #
  #------------------------#
  changePassword: (old_password, new_password) => @useCase.changePassword(old_password, new_password)
  passwordChanged: =>
    @pageContent.find('#message').text("Your new password has been changed")
  passwordNotChanged: (errorCode, errorName) =>
    @pageContent.find('#message').text("Changed password failure. Message was #{errorName}: #{errorCode}. Propably wrong current password or new password to weak.")

  #------------------------#
  #      EMAIL CHANGE      #
  #------------------------#
  changeEmail: (new_email, password) => @useCase.changeEmail(new_email, password)
  emailChanged: =>
    @pageContent.find('#message').text("Successfuly changed email")
  emailNotChanged: (errorCode, errorName) =>
    @pageContent.find('#message').text("Changing email failure. Message was #{errorName}: #{errorCode}. Provided email already exists in database or password not provided.")

  #------------------------#
  #     ACCOUNT DELETE     #
  #------------------------#
  deleteAccount: (password) => @useCase.deleteAccount(password)
  accountDeleted: => @loadForms('Account deleted successfully')
  accountNotDeleted: (errorCode, errorName) =>
    @pageContent.find('#message').text("Account delete failure. Message was #{errorName}: #{errorCode}. Propably wrong password.")

  #------------------------#
  #         LOGOUT         #
  #------------------------#
  logout: => @useCase.logout(@logoutSuccess, @logoutFailure)
  logoutSuccess: => @loadForms('Logout successful')
  logoutFailure: (errorCode, errorName) =>