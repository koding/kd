module.exports = class HeaderView extends JView

  constructor : (options = {}) ->
    options.cssClass = 'main-header'
    options.tagName  = 'header'

    super options

    @download = new KDCustomHTMLView
      tagName   : 'a'
      cssClass  : 'download-button'
      attributes:
        href    : '#'
        title   : 'Download'


  pistachio: ->

    """
    <div class='inner-wrapper'>
      <figure class='logo small'></figure>
      <nav>
        <a href='/About'>ABOUT</a>
        <a href='/Guide/Getting+started'>GUIDE</a>
        <a href='/API'>API</a>
        <a href='https://koding.com'>COMMUNITY</a>
        <a href='/Build'>BUILD</a>
        <a href='http://github.com/koding/kd' id='fork-us' title='Fork us on Github' target='_blank'>FORK US ON GITHUB</a>
        {{> this.download}}
      </nav>
    </div>
    """
