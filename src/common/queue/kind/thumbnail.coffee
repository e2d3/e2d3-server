Promise = require 'bluebird'

queue = require '../index'

thumbnail = queue.kind 'thumbnail'

get = () ->
  thumbnail.get()

post = (params) ->
  thumbnail.post params

module.exports =
  get: get
  post: post
