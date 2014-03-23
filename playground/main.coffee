paragraphs   = ["Frankfurter ground round jowl, tongue flank tenderloin pastrami.  Ball tip jowl ground round, leberkas drumstick pork chop doner.  Short loin venison pork belly beef beef ribs shank.  Beef ribs ham bacon pork loin salami, biltong strip steak pastrami ham hock boudin pork belly.","Kevin flank tenderloin porchetta pork biltong salami, capicola beef ribs shankle turducken doner cow corned beef.  Short ribs biltong tenderloin turducken pork doner hamburger kielbasa venison ground round drumstick chuck jerky.  Swine rump ham landjaeger.  Venison ribeye biltong meatloaf shank doner tongue chicken ham filet mignon ball tip hamburger tenderloin ground round.","Tri-tip spare ribs ham hamburger landjaeger.  Ground round flank jowl, rump chuck prosciutto frankfurter tongue short ribs turkey jerky pork chop bacon venison pork belly.  Tail bresaola brisket shoulder leberkas.  Kielbasa cow turkey chuck, rump jowl meatball.  Porchetta bresaola shankle pork loin shoulder beef ribs.  Biltong tenderloin landjaeger t-bone bacon hamburger.","Beef ribs shank biltong drumstick rump salami venison pork loin prosciutto ribeye filet mignon frankfurter meatloaf.  Chuck turducken ground round shoulder tail fatback.  Turkey hamburger frankfurter shank fatback pork pork belly short loin porchetta.  Shankle pork loin shoulder ham hock.  Pastrami pig ham chicken flank bresaola.","Beef ribs biltong filet mignon bacon rump shankle landjaeger pork chop chuck ball tip kevin cow.  Drumstick corned beef salami, biltong beef shoulder spare ribs flank sirloin beef ribs bacon.  Rump jowl tail, short loin doner kielbasa pig beef ribs drumstick pastrami jerky strip steak.  Ham fatback andouille shankle drumstick pork loin.","Beef ribs brisket pork belly, ball tip venison short loin pork chop sausage bacon kielbasa jerky.  Short ribs sirloin pork chop pork loin tenderloin brisket tri-tip bresaola.  Ham fatback drumstick venison strip steak sausage prosciutto leberkas biltong meatball pork loin doner.  Flank chuck brisket pork loin turkey.","Leberkas ribeye beef ribs, filet mignon brisket short loin pork tenderloin rump sirloin.  Sirloin bacon beef, ball tip doner pork belly pork loin strip steak venison chicken.  Spare ribs tri-tip andouille capicola pork belly sausage landjaeger, bacon kevin chuck shoulder hamburger leberkas biltong ham.  Beef ribs filet mignon shoulder meatloaf.  Tri-tip pig ribeye venison short loin meatball.","Meatball brisket porchetta, shankle jowl beef sausage chuck landjaeger ground round cow ham hock t-bone shank.  Pork belly cow kielbasa, t-bone bacon shoulder rump.  Shankle beef ribs turducken, ham filet mignon corned beef bacon beef meatloaf swine t-bone ground round.  Boudin leberkas shoulder ribeye biltong chuck.  Cow hamburger turducken, salami pastrami porchetta pork chop kevin jowl shoulder swine chuck bresaola.  Chicken ribeye turkey pork pancetta leberkas.","Tongue jerky meatball, kielbasa short loin pork shank turkey pork belly boudin porchetta biltong.  Turducken beef ribs chicken swine turkey chuck.  Tongue ham hock chuck turkey, pig fatback tail frankfurter.  Jowl kielbasa shankle landjaeger doner capicola, filet mignon beef pork short loin.  Flank pork chop tongue pork belly venison, bacon tri-tip frankfurter filet mignon fatback turkey t-bone biltong boudin.  Corned beef pancetta ribeye jerky, tenderloin doner strip steak swine.","Venison turducken pig porchetta boudin.  Flank biltong beef ribs prosciutto.  Pig pork rump drumstick, corned beef bresaola ham hock shankle doner tenderloin flank leberkas.  Ribeye prosciutto chicken turkey bacon.  Shoulder pork chop drumstick t-bone short loin meatloaf prosciutto.  Pancetta salami t-bone, cow swine turducken corned beef ground round shankle pork filet mignon frankfurter tenderloin.  Flank ham hock strip steak, corned beef salami short loin hamburger spare ribs pig boudin meatball tri-tip sausage."]
container    = new KDView
addParagraph = -> scrollView.setPartial "<p>#{paragraphs[KD.utils.getRandomNumber(10)-1]}</p>"

container.addSubView scrollView = new KDScrollView
  ownScrollBars : yes

scrollView.setStyle
  margin     : '100px auto'
  width      : 300
  height     : 200
  background : '#1aa5fd'
  color      : 'white'
  padding    : 30


container.addSubView new KDButtonView
  title     : "Add a paragraph"
  callback  : addParagraph


container.addSubView new KDButtonView
  title     : "Remove a paragraph"
  callback  : ->
    $paragraphs = scrollView.$('p')
    $paragraphs[$paragraphs.length - 1]?.remove()

addParagraph() for i in [0...100]

container.appendToDomBody()
























