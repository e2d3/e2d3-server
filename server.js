require('app-module-path').addPath(__dirname + '/dist');

var app = require('app');

app.listen(process.env.PORT || 8000, function () {
  if (process.send) {
    process.send('Server listening at http://0.0.0.0:' + process.env.PORT);
  }
});
