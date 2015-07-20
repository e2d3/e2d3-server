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
    baseUrl: "/files/github/#{path}/contents/#{name}"
    scriptType: scriptType
    dataType: dataType

  ret

router.get '/github/*', (req, res) ->
  path = req.params[0]

  github.getAsync "/repos/#{path}/contents"
    .spread (apires, body) ->
      promises = {}
      if apires.statusCode == 200
        for dir in body
          promises[dir.name] = github.getAsync dir.url
      else if apires.statusCode == 304
        # ディレクトリ取得APIの結果が変更無しであれば、
        # 子供も変更がないので保存されているキャッシュから取得する
        for dir in body
          promises[dir.name] = github.getFromETagCacheAsync dir.url
      Promise.props promises
    .then (result) ->
      charts = []
      for name, data of result
        [apires, children] = data
        charts.push createData path, name, children
      res.json charts: charts
      undefined
    .catch (err) ->
      res.status(500).json err

module.exports = router
