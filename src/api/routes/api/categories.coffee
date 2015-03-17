express = require 'express'
request = require 'request-json'
Promise = require 'bluebird'

github = Promise.promisifyAll request.createClient 'https://api.github.com/',
  qs:
    client_id: 'b83c999af546ee06597e'
    client_secret: 'a3989b980d6ed1597a988784b0a256b99d1b1732'

router = express.Router()

createData = (path, name, children) ->
  scriptType = 'js'
  dataType = 'tsv'

  for child in children
    match = null
    if match = child.name.match /^main\.(js|coffee|jsx)$/
      scriptType = match[1]
    if match = child.name.match /^data\.(tsv|csv|json)$/
      dataType = match[1]

  ret =
    title: "#{path}/#{name}"
    baseUrl: "/files/github/#{path}/master/#{name}"
    scriptType: scriptType
    dataType: dataType

  ret

router.get '/github/*:path', (req, res) ->
  path = req.path.replace /^\/github\//, ''

  github.getAsync "repos/#{path}/contents"
    .spread (apires, body) ->
      promises = {}
      for dir in body
        promises[dir.name] = github.getAsync dir.url
      Promise.props promises
    .then (result) ->
      charts = []
      for name, data of result
        [apires, children] = data
        charts.push createData path, name, children
      res.json charts: charts
      undefined
    .catch (err) ->
      console.log err
      res.status(500).json err

module.exports = router
