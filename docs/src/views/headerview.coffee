module.exports = class HeaderView extends JView

  constructor : (options = {}) ->

    options.cssClass = 'intro home-section'
    options.tagName  = 'section'

    super options

    @download = new KDCustomHTMLView
      tagName   : 'a'
      partial   : 'DOWNLOAD THE THING'
      cssClass  : 'download-button'
      attributes: href : '#'


  pistachio: ->

    """
    <div class='inner-wrapper'>
      <nav>
        <a href='/About'>ABOUT</a>
        <a href='/Guide/Getting+started'>GUIDE</a>
        <a href='/API'>API</a>
        <a href='https://koding.com'>COMMUNITY</a>
        <a href='/Build'>BUILD</a>
        <a href='http://github.com/koding/kd' id='fork-us' target='_blank'>FORK US ON GITHUB</a>
      </nav>
      <figure class='logo'></figure>
      <figure class='logo small'></figure>
      <h2><span>A framework to change your drinking habits.</span></h2>
      {{> this.download}}
    </div>
    """
