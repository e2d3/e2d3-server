config =
  switch process.env.NODE_ENV
    when 'development'
      domainApi: 'a.d.e2d3.org'
      domainShare: 's.d.e2d3.org'
      fileBase: 'http://a.d.e2d3.org:8000/files'
      dataBase: 'http://s.d.e2d3.org:8000/data'
      corsOrigin: 'http://s.d.e2d3.org:8000'
      databaseType: 'mongodb'
      databaseUrl: 'mongodb://localhost/e2d3'
    when 'staging'
      domainApi: 'a.s.e2d3.org'
      domainShare: 's.s.e2d3.org'
      fileBase: 'http://a.s.e2d3.org/files'
      dataBase: 'http://s.s.e2d3.org/data'
      corsOrigin: 'http://s.s.e2d3.org'
    else
      domainApi: 'a.e2d3.org'
      domainShare: 's.e2d3.org'
      fileBase: 'https://a.e2d3.org/files'
      dataBase: 'https://d.e2d3.org/data'
      corsOrigin: 'https://s.e2d3.org'

module.exports = config
