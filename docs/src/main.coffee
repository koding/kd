MainView = require './views/mainview'

# bootstrap the thing.
do ->
  KD.registerSingleton 'router',   new KDRouter
  KD.registerSingleton 'mainView', new MainView

  {router, mainView} = KD.singletons

  handleRoute = ({params : {page, section}, query}) ->

    log page, section, query

    mainView.showPage page, section

  # add the routes
  router.addRoutes
    '/:page?'         : handleRoute
    '/:page/:section' : handleRoute


  router.listen()