express = require 'express'
Promise = require 'bluebird'
yaml = require 'js-yaml'

github = require '../../adapters/github'

router = express.Router()

loadTags = (result) ->
  [apires, body] = result

  tags = yaml.safeLoad new Buffer(body.content, body.encoding).toString()

  ret = {}
  for own key, value of tags
    value.forEach (name) ->
      ret[name] ?= []
      ret[name].push key
  ret

createCharts = (path, result, tags) ->
  ret = []
  for name, data of result
    continue if name == '.tags'
    [apires, children] = data
    ret.push createData path, name, tags[name], children
  ret

createData = (path, name, tags, children) ->
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
    tags: tags ? []
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
        promises['.tags'] = github.getAsync "/repos/#{path}/contents/tags.yml"
        for dir in body
          if dir.type == 'dir'
            promises[dir.name] = github.getAsync dir.url
      else if apires.statusCode == 304
        # ディレクトリ取得APIの結果が変更無しであれば、
        # 子供も変更がないので保存されているキャッシュから取得する
        promises['.tags'] = github.getFromETagCacheAsync "/repos/#{path}/contents/tags.yml"
        for dir in body
          if dir.type == 'dir'
            promises[dir.name] = github.getFromETagCacheAsync dir.url
      Promise.props promises
    .then (result) ->
      tags = loadTags result['.tags']
      charts = createCharts path, result, tags
      res.json charts: charts
      undefined
    .catch (err) ->
      console.error err
      res.status(500).json err

module.exports = router
