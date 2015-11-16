var socketIO = require('socket.io'),
    redis = require('redis').createClient(),
    express = require('express'),
    app = express();
    request = require('request');

redis.subscribe('change-hmds');

app.use(express.static('public'));
var server = app.listen(4567, function () {
  var host = server.address().address;
  var port = server.address().port;
});
app.get('/hmds', function(req, res){
  request("http://localhost:3000/hmds.json", function(err, resp, body){
    res.send(body);
  });
});

io = socketIO.listen(server);
io.on('connection', function(socket){
  redis.on('message', function(channel, message){
    socket.emit('change-hmds', JSON.parse(message));
  });
});



