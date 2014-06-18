$.fn.replaceContent = (element) ->
  this.empty()
  this.append element

serverSide      = new ServerSide()
securityManager = new SecurityManager()
useCase         = new UseCase()
guiAdapter      = new GuiAdapter()

guiAdapter.setDependency useCase
useCase   .setDependency serverSide,
                         securityManager,
                         guiAdapter
guiAdapter.loadPage()