require './utils/polyfills'

module.exports = require './core/kd'

module.exports.extend

  debug                          : require 'debug'

  AutoComplete                   : require "./components/autocomplete/autocomplete"
  AutoCompleteController         : require "./components/autocomplete/autocompletecontroller"
  AutoCompletedItem              : require "./components/autocomplete/autocompleteditems"
  AutoCompleteFetchingItem       : require "./components/autocomplete/autocompletefetchingitem"
  AutoCompleteListView           : require "./components/autocomplete/autocompletelist"
  AutoCompleteListItemView       : require "./components/autocomplete/autocompletelistitem"
  AutoCompleteNothingFoundItem   : require "./components/autocomplete/autocompletenothingfounditem"
  AutocompleteUnselecteableItem  : require "./components/autocomplete/autocompleteunselecteableitem"
  MultipleInputListView          : require "./components/autocomplete/multipleinputlistview"
  MultipleInputView              : require "./components/autocomplete/multipleinputview"
  MultipleListItemView           : require "./components/autocomplete/multiplelistitemview"
  NoAutocompleteInputView        : require "./components/autocomplete/noautocompleteinputview"
  NoAutocompleteMultipleListView : require "./components/autocomplete/noautocompletemultiplelistview"
  SimpleAutocomplete             : require "./components/autocomplete/simpleautocomplete"
  ButtonBar                      : require "./components/buttons/buttonbar"
  ButtonGroupView                : require "./components/buttons/buttongroupview"
  JButtonMenu                    : require "./components/buttons/buttonmenu"
  ButtonView                     : require "./components/buttons/buttonview"
  ButtonViewWithMenu             : require "./components/buttons/buttonviewwithmenu"
  ToggleButton                   : require "./components/buttons/togglebutton"
  ContextMenu                    : require "./components/contextmenu/contextmenu"
  JContextMenuItem               : require "./components/contextmenu/contextmenuitem"
  JContextMenuTreeView           : require "./components/contextmenu/contextmenutreeview"
  JContextMenuTreeViewController : require "./components/contextmenu/contextmenutreeviewcontroller"
  CounterDigitView               : require "./components/counter/counterdigitview"
  CounterView                    : require "./components/counter/counterview"
  DiaContainer                   : require "./components/dia/diacontainer"
  DiaJoint                       : require "./components/dia/diajoint"
  DiaObject                      : require "./components/dia/diaobject"
  DiaScene                       : require "./components/dia/diascene"
  DialogView                     : require "./components/dialog/dialogview"
  Flex                           : require "./components/flexsplit/flex"
  FlexResizer                    : require "./components/flexsplit/flexresizer"
  FlexSplit                      : require "./components/flexsplit/flexsplit"
  FlexStorage                    : require "./components/flexsplit/flexstorage"
  FormView                       : require "./components/forms/formview"
  FormViewWithFields             : require "./components/forms/formviewwithfields"
  HeaderView                     : require "./components/header/headerview"
  WebcamView                     : require "./components/image/webcamview"
  CheckBox                       : require "./components/inputs/checkbox"
  CustomCheckBox                 : require "./components/inputs/customcheckbox"
  ContentEditableView            : require "./components/inputs/contenteditableview"
  DelimitedInputView             : require "./components/inputs/delimitedinputview"
  HitEnterInputView              : require "./components/inputs/hitenterinputview"
  InputCheckboxGroup             : require "./components/inputs/inputcheckboxgroup"
  InputRadioGroup                : require "./components/inputs/inputradiogroup"
  InputSwitch                    : require "./components/inputs/inputswitch"
  InputValidator                 : require "./components/inputs/inputvalidator"
  InputView                      : require "./components/inputs/inputview"
  LabelView                      : require "./components/inputs/labelview"
  MultipleChoice                 : require "./components/inputs/multiplechoice"
  OnOffSwitch                    : require "./components/inputs/onoffswitch"
  SelectBox                      : require "./components/inputs/selectbox"
  TokenizedInput                 : require "./components/inputs/tokenizedinputview"
  WmdInput                       : require "./components/inputs/wmdinput"
  ListItemView                   : require "./components/list/listitemview"
  ListView                       : require "./components/list/listview"
  ListViewBox                    : require "./components/list/listviewbox"
  ListViewController             : require "./components/list/listviewcontroller"
  LoaderView                     : require "./components/loader/loaderview"
  BlockingModalView              : require "./components/modals/blockingmodalview"
  ModalView                      : require "./components/modals/modalview"
  ModalViewStack                 : require "./components/modals/modalviewstack"
  ModalViewWithForms             : require "./components/modals/modalviewwithforms"
  NotificationView               : require "./components/notifications/notificationview"
  OverlayView                    : require "./components/overlay/overlayview"
  SpotlightView                  : require "./components/overlay/spotlightview"
  ProgressBarView                : require "./components/progressbar/progressbarview"
  CustomScrollView               : require "./components/scrollview/customscrollview"
  CustomScrollViewWrapper        : require "./components/scrollview/customscrollviewinner"
  ScrollThumb                    : require "./components/scrollview/scrollthumb"
  ScrollTrack                    : require "./components/scrollview/scrolltrack"
  ScrollView                     : require "./components/scrollview/scrollview"
  SliderBarHandleView            : require "./components/sliderbar/sliderbarhandleview"
  SliderBarView                  : require "./components/sliderbar/sliderbarview"
  SlidePageView                  : require "./components/slideshow/slidepageview"
  SlideShowView                  : require "./components/slideshow/slideshowview"
  SplitComboView                 : require "./components/split/splitcomboview"
  SplitViewPanel                 : require "./components/split/splitpanel"
  SplitResizer                   : require "./components/split/splitresizer"
  SplitView                      : require "./components/split/splitview"
  TabHandleContainer             : require "./components/tabs/tabhandlecontainer"
  TabHandleMoveNav               : require "./components/tabs/tabhandlemovenav"
  TabHandleView                  : require "./components/tabs/tabhandleview"
  TabPaneView                    : require "./components/tabs/tabpaneview"
  TabView                        : require "./components/tabs/tabview"
  TabViewWithForms               : require "./components/tabs/tabviewwithforms"
  TimeAgoView                    : require "./components/time/timeagoview"
  Tooltip                        : require "./components/tooltip/tooltip"
  JTreeItemView                  : require "./components/tree/treeitemview"
  JTreeView                      : require "./components/tree/treeview"
  JTreeViewController            : require "./components/tree/treeviewcontroller"
  FileUploadArea                 : require "./components/upload/fileuploadarea"
  FileUploadListItemView         : require "./components/upload/fileuploadlistitemview"
  FileUploadListView             : require "./components/upload/fileuploadlistview"
  FileUploadThumbItemView        : require "./components/upload/fileuploadthumbitemview"
  FileUploadThumbListView        : require "./components/upload/fileuploadthumblistview"
  FileUploadView                 : require "./components/upload/fileuploadview"
  MultipartUploader              : require "./components/upload/multipartuploader"
  Controller                     : require "./core/controller"
  CustomHTMLView                 : require "./core/customhtmlview"
  EventEmitter                   : require "./core/eventemitter"
  EventEmitterWildcard           : require "./core/eventemitterwildcard"
  Object                         : require "./core/object"
  Router                         : require "./core/router"
  View                           : require "./core/view"
  ViewController                 : require "./core/viewcontroller"
  WindowController               : require "./core/windowcontroller"
