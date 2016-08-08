var Topic = React.createClass({

  propTypes: {
    id: React.PropTypes.number,
    value: React.PropTypes.string,
    link: React.PropTypes.link,
    mentions: React.PropTypes.number,
    topUrls: React.PropTypes.array,
    topUsernames: React.PropTypes.array,
    topHashtags: React.PropTypes.array
  },

  loadTopicFromServer: function() {
    $.ajax({
      url: this.props.link,
      dataType: 'json',
      cache: false,
      success: function(topic) {
        this.setState({data: topic.data});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(url, status, err.toString());
      }.bind(this)
    });
  },

  getInitialState: function() {
    return {data: this.props.data};
  },

 componentDidMount: function() {
    this.loadTopicFromServer();
    setInterval(this.loadTopicFromServer, 1000);
  },

  render: function() {
    return (
      <div className="row">
        <div className="row">
          <div className="col-md-12">
            <h1>
              <a href={this.props.link}>{this.props.value}</a>
            </h1>
          </div>
        </div>
        <div className="row">
          <div className="col-md-3">
            <h2>Mentions: {this.state.data.mentions}</h2>
            <img className="img-rounded img-responsive" src={this.props.image_link}></img>
          </div>
          <div className="col-md-3">
            <List title="Top Usernames" listItems={this.state.data.topUsernames}></List>
          </div>
          <div className="col-md-3">
            <List title="Top Hashtags" listItems={this.state.data.topHashtags}></List>
          </div>
          <div className="col-md-3">
            <List title="Top Urls" listItems={this.state.data.topUrls}></List>
          </div>
        </div>
      </div>
    );
  }
});
