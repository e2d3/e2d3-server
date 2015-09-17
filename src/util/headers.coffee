module.exports =
  cloneValidHeaders: (headers, contentLength) ->
    newheaders = {}
    copyheader = (name) ->
      newheaders[name] = headers[name] if headers[name]
    copyheader 'cache-control'
    copyheader 'last-modified'
    if contentLength?
      newheaders['content-length'] = contentLength
    else
      copyheader 'content-length'
    newheaders
