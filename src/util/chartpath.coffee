config = require 'config'

module.exports = (chart) ->
  if chart.path.indexOf '://' == -1
    path = chart.path.split('/')
    switch path.length
      when 1 then "#{config.fileBase}/github/e2d3/e2d3-contrib/contents/#{path[0]}"
      when 2 then "#{config.fileBase}/github/#{path[0]}/#{path[1]}/contents"
      when 3 then "#{config.fileBase}/github/#{path[0]}/#{path[1]}/contents/#{path[2]}"
      else chart.path
  else
    chart.path
