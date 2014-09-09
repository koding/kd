module.exports = class HeaderView extends KDView

  constructor : (options = {}) ->
    options.cssClass = 'main-header'
    options.tagName  = 'header'
    options.partial  =
      """
      <div class='inner-wrapper'>
        <figure class='logo small'></figure>
        <nav>
          <a class='hidden' href='/About'>ABOUT</a>
          <a class='hidden' href='/Guide/Getting+started'>GUIDE</a>
          <a class='hidden' href='/API'>API</a>
          <a class='hidden' href='https://koding.com'>COMMUNITY</a>
          <a class='hidden' href='/Build'>BUILD</a>
          <a href='http://github.com/koding/kd' id='fork-us' title='Fork us on Github' target='_blank'>FORK US ON GITHUB</a>
        </nav>
      </div>
      """

    super options

    @download = new KDCustomHTMLView
      tagName   : 'a'
      cssClass  : 'download-button'
      attributes:
        href    : '#'
        title   : 'Download'


    @once 'viewAppended', => @addSubView @download, 'nav'