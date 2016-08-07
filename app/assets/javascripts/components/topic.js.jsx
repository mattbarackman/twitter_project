var Topic = React.createClass({
  propTypes: {
    name: React.PropTypes.string,
    mentions: React.PropTypes.number,
    topWords: React.PropTypes.array,
    topUsers: React.PropTypes.array,
    topHashtags: React.PropTypes.array
  },

  render: function() {
    return (
      <div>
        <h1>{this.props.name}</h1>
        <div>Mentions: {this.props.mentions}</div>
        <List title="Top Words" listItems={this.props.topWords}></List>
        <List title="Top Users" listItems={this.props.topUsers}></List>
        <List title="Top Hashtags" listItems={this.props.topHashtags}></List>
      </div>
    );
  }
});
