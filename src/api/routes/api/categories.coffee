express = require 'express'
Promise = require 'bluebird'

github = require '../../adapters/github'

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

  github.getAsync "/repos/#{path}/contents"
    .spread (apires, body) ->
      useCache = apires.statusCode == 304

      promises = {}
      for dir in body
        if useCache
          promises[dir.name] = github.getFromETagCacheAsync dir.url
        else
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
