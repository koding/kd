
class ListItem extends KDListItemView

  partial : ->

    @setCss 'padding-left' : '50px'

    {randomIndex, id} = @getData()
    "#{id} numarali itemim ulan indexim de #{randomIndex or 'yok'}!!<br><br>"


mainView = new KDView
KDView.appendToDOMBody mainView

listController = new KDListViewController
  itemClass : ListItem
  # boxed : yes
  lastToFirst : yes


id = 0
mainView.addSubView input = new KDInputView

mainView.addSubView new KDButtonView
  title    : 'Random indexli eleman ekle'
  callback : ->
    randomIndex = parseInt(input.getValue(), 10) or 0
    listController.addItem {title : Date.now(), id : ++id, randomIndex}, randomIndex
    log listController.getListView().items.map (item) -> item.data.id
    log listController.itemsOrdered.map (item) -> item.data.id


mainView.addSubView listController.getView()

# KD.utils.defer ->

#   for i in [0...10]
#     if listController.itemsOrdered.length > 3
#       randomIndex = KD.utils.getRandomNumber listController.itemsOrdered.length
#     # randomIndex = 0
#     log randomIndex
#     listController.addItem {title : Date.now(), id : ++id, randomIndex}, randomIndex
#     # log listController.itemsOrdered.map (item) -> item.data.id


# listController.getListItems()

window.kamil = listController