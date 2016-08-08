var ListItem = React.createClass({
  propTypes: {
    value: React.PropTypes.string,
    count: React.PropTypes.number,
    link: React.PropTypes.string
  },
  render: function() {
    return (
      <li>
        <p className="bg-info">
          <a href={this.props.link}>{this.props.value}</a>
          <span className="pull-right">{this.props.count}</span>
        </p>
      </li>
    );
  }
});
