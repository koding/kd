module.exports = class FooterView extends JView

  constructor : (options = {}) ->

    options.tagName  = 'footer'

    super options


  pistachio: ->

    """
    <div class='inner-wrapper'>
      <p class='about-kd'>KD is free and open-source! <br> by Koding with love <3</p>
      <nav>
        <a href='#'>Terms</a>
        <a href='#'>Legal</a>
        <a href='#'>Blog</a>
        <a href='#'>Contact</a>
      </nav>
    </div>
    """