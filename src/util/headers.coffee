module.exports =
  cloneValidHeaders: (headers) ->
    newheaders = {}
    copyheader = (name) ->
      newheaders[name] = headers[name] if headers[name]
    copyheader 'cache-control'
    copyheader 'last-modified'
    copyheader 'content-length'
    newheaders
