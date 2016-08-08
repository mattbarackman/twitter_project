var List = React.createClass({

  propTypes: {
    title: React.PropTypes.string,
    listItems: React.PropTypes.array
  },

  renderList() {
    return this.props.listItems.map( listItem => <ListItem key={listItem.key} value={listItem.value} count={listItem.count} link={listItem.link} /> );
  },

  render() {
    return (
      <div className="top-items-list">
        <h2>{this.props.title}</h2>
        <ul className="list-unstyled">
          <FlipMove easing="cubic-bezier(0, 0.7, 0.8, 0.1)">
            { this.renderList() }
          </FlipMove>
        </ul>
      </div>
    );
  }
})