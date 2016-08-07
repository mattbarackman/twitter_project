var ListItem = React.createClass({
  propTypes: {
    value: React.PropTypes.string,
    score: React.PropTypes.number,
    link: React.PropTypes.string
  },
  render: function() {
    return (
      <li>
        <p className="bg-info">
          <a href={this.props.link}>{this.props.value}</a>
        </p>
      </li>
    );
  }
});
