config = require 'config'

module.exports =
  encode: (baseUrl) ->
    if ret = baseUrl.match new RegExp("/github/e2d3/e2d3-contrib/contents/([^/]+)$")
      "#{ret[1]}"
    else if ret = baseUrl.match new RegExp("/github/([^/]+)/([^/]+)/contents$")
      "#{ret[1]}/#{ret[2]}"
    else if ret = baseUrl.match new RegExp("/github/([^/]+)/([^/]+)/contents/([^/]+)$")
      "#{ret[1]}/#{ret[2]}/#{ret[3]}"
    else
      baseUrl

  decode: (path) ->
    if path.indexOf '://' == -1
      splitted = path.split('/')
      switch splitted.length
        when 1 then "#{config.fileBase}/github/e2d3/e2d3-contrib/contents/#{splitted[0]}"
        when 2 then "#{config.fileBase}/github/#{splitted[0]}/#{splitted[1]}/contents"
        when 3 then "#{config.fileBase}/github/#{splitted[0]}/#{splitted[1]}/contents/#{splitted[2]}"
        else path
    else
      path
