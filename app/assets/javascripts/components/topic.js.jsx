var Topic = React.createClass({

  propTypes: {
    id: React.PropTypes.number,
    value: React.PropTypes.string,
    mentions: React.PropTypes.number,
    topUrls: React.PropTypes.array,
    topUserMentions: React.PropTypes.array,
    topHashtags: React.PropTypes.array
  },

  loadTopicFromServer: function() {

    url = "/topics/" + this.props.id

    $.ajax({
      url: url,
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
          <div className="col-md-3">
            <h1>{this.props.value}</h1>
            <div>Mentions: {this.state.data.mentions}</div>
          </div>
          <div className="col-md-3">
            <List title="Top User Mentions" listItems={this.state.data.topUserMentions}></List>
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
