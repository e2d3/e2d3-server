config =
  if process.env.NODE_ENV == 'development'
    domainApi: 'a.d.e2d3.org'
    domainShare: 's.d.e2d3.org'
    fileBase: 'http://a.d.e2d3.org:8000/files'
    corsOrigin: 'http://s.d.e2d3.org:8000'
  else if process.env.NODE_ENV == 'staging'
    domainApi: 'a.s.e2d3.org'
    domainShare: 's.s.e2d3.org'
    fileBase: 'http://a.s.e2d3.org/files'
    corsOrigin: 'http://s.s.e2d3.org'
  else
    domainApi: 'a.e2d3.org'
    domainShare: 's.e2d3.org'
    fileBase: 'https://a.e2d3.org/files'
    corsOrigin: 'https://s.e2d3.org'

module.exports = config
