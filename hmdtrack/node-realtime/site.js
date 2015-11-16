var React = require('react'),
    ReactDOM = require('react-dom'),
    _ = require('lodash'),
    socket = io.connect("localhost:4567");
    require ('./styles.less');

const initialModel = window.INITIAL_MODEL;

var MainWindow = React.createClass({
  getInitialState() {
    return {hmds: []};
  },

  handleChange(data) {
    this.setState({hmds: data});
  },

  componentDidMount() {
    $.get('hmds').then(function(data){
      this.setState({hmds: JSON.parse(data)})
    }.bind(this));
    socket.on('change-hmds', this.handleChange);
  },

  render() {
    let rows = this.state.hmds.map(function(hmd){
      return (
        <tr>
          <td><img className="headsetImg" width="300px" height="200px" src={hmd.image_url}/></td>
          <td>{hmd.name}</td>
          <td>{hmd.company}</td>
          <td className={hmd.state}>{hmd.state}</td>
          <td><a href={"http://localhost:3000/hmds/"+hmd.id+"/edit"}>Edit</a></td>
        </tr>
      );
    });
    return (
      <div>
        <table className="VRtab">
          <tr>
            <th></th>
            <th>HMD Name</th>
            <th>Company</th>
            <th>State</th>
            <th></th>
          </tr>
          {rows}
        </table>
      </div>
    );
  }
})

ReactDOM.render(<MainWindow />, document.getElementById("main"));
