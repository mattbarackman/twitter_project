var ListItem = React.createClass({
  propTypes: {
    value: React.PropTypes.string,
    score: React.PropTypes.number
  },
  render: function() {
    return (
      <li>
        <span> {this.props.value}</span>
      </li>
    );
  }
});
