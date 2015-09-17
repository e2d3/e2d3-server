REGEX_E2D3_CONTRIB = '^e2d3/e2d3-contrib/contents/([^/]+)/'

ALIASES = {}

module.exports = (path) ->
  match = (new RegExp(REGEX_E2D3_CONTRIB)).exec path
  if match != null
    actual = ALIASES[match[1]]
    if actual?
      path = path.replace(new RegExp(REGEX_E2D3_CONTRIB), "e2d3/e2d3-contrib/contents/#{actual}/")
  path
