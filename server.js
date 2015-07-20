require('app-module-path').addPath(__dirname + '/dist');

var app = require('app');

app.listen(process.env.PORT || 8000);
