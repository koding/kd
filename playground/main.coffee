
class ListItem extends KDListItemView

  partial : ->

    {randomIndex, id} = @getData()
    "#{id} numarali itemim ulan indexim de #{randomIndex or 'yok'}!!"


mainView = new KDView
KDView.appendToDOMBody mainView

listController = new KDListViewController
  boxed : yes
  itemClass : ListItem


id = 0
mainView.addSubView new KDButtonView
  title    : 'Random indexli eleman ekle'
  callback : ->
    if listController.itemsOrdered.length > 3
      randomIndex = KD.utils.getRandomNumber listController.itemsOrdered.length
    listController.addItem {title : Date.now(), id : ++id, randomIndex}, randomIndex

mainView.addSubView listController.getView()

# And append it to DOM

