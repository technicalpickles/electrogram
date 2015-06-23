ReactEmoji    = require "react-emoji"

Message = React.createClass
  getInitialState: ->
    return { width: "800px" }

  updateDimensions: ->
    console.log "Message Resize: max-width: #{($(window).width()-50)}"
    this.setState({width: ($(window).width() - 50)})
  componentWillMount: ->
    this.updateDimensions()
  componentDidMount: ->
    window.addEventListener("resize", this.updateDimensions)
    twttr.widgets.load(@getDOMNode())
  componentWillUnmount: ->
    window.removeEventListener("resize", this.updateDimensions)
  mixins: [ ReactEmoji ]

  render: ->
    if @props.msg.text.match(/^<(.*\.(:?jpg|jpeg|gif|png))>$/)
      imgStyle =
        "maxWidth": "#{@state.width- 50}px"
      <div className="message">
        <span className="avatar">
          <img src={ @props.user.profile.image_192 } />
        </span>
        <h4 className="author">{ @props.user.name }</h4>
        <img className="chat-image" style={imgStyle} src={ @props.msg.text.replace(/^</, '').replace(/>$/, '') } />
      </div>
    else
      matches = @props.msg.text.match(/^<https:\/\/twitter\.com\/([^\/]+)\/status\/(.*)>$/)
      if matches and matches[2]?
        <div className="Twitter">
          <a className="twitter-timeline"
          href={this.props.link}
          data-widget-id={matches[2]}
          data-screen-name={matches[1]} >

          Tweets by {matches[1]}
          </a>
        </div>
      else
        <div className="message">
          <span className="avatar">
            <img src={ @props.user.profile.image_192 } />
          </span>
          <h4 className="author">{ @props.user.name }</h4>
          <div className="content text">{ @emojify(@props.msg.text) }</div>
        </div>

module.exports = Message
