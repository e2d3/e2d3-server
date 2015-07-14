webshot = require 'webshot'

url = 'http://sd.e2d3.org:8000/2da7acb/d1608d2bedc45420f23db6577eacf77f'

options =
  windowSize:
    width: 1200
    height: 630
  defaultWhiteBackground: true
  renderDelay: 5000
  errorIfStatusIsNot200: true
  zoomFactor: 2.0

webshot url, 'thumbnail.png', options, (err) ->
  console.log err
