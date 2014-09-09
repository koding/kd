module.exports = class FooterView extends KDView

  constructor : (options = {}) ->

    options.tagName  = 'footer'

    super options

  viewAppended: ->

    @setPartial @partial()


  partial: ->

    """
    <div class='inner-wrapper'>
      <p class='about-kd'>KD is free and open-source! <br> by Koding with <i><3</i></p>
      <nav>
        <a href='#'>Terms</a>
        <a href='#'>Legal</a>
        <a href='#'>Blog</a>
        <a href='#'>Contact</a>
      </nav>
    </div>
    """