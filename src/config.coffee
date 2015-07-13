config =
  switch process.env.NODE_ENV
    when 'development'
      domainApi: 'ad.e2d3.org'
      domainShare: 'sd.e2d3.org'
      fileBase: 'http://ad.e2d3.org:8000/files'
      dataBase: 'http://sd.e2d3.org:8000/data'
      corsOrigin: 'http://sd.e2d3.org:8000'
      databaseType: 'mongodb'
      databaseUrl: 'mongodb://localhost/e2d3'
    when 'testing'
      domainApi: 'at.e2d3.org'
      domainShare: 'st.e2d3.org'
      fileBase: 'http://at.e2d3.org/files'
      dataBase: 'http://st.e2d3.org/data'
      corsOrigin: 'http://st.e2d3.org'
      databaseType: 'mockdb'
    when 'staging'
      domainApi: 'as.e2d3.org'
      domainShare: 'ss.e2d3.org'
      fileBase: 'http://as.e2d3.org/files'
      dataBase: 'http://ss.e2d3.org/data'
      corsOrigin: 'http://ss.e2d3.org'
      databaseType: 'mockdb'
    else
      domainApi: 'a.e2d3.org'
      domainShare: 's.e2d3.org'
      fileBase: 'https://a.e2d3.org/files'
      dataBase: 'https://s.e2d3.org/data'
      corsOrigin: 'https://s.e2d3.org'
      databaseType: 'mockdb'

config.isInTest = typeof global.it == 'function'
config.databaseType = 'mockdb' if config.isInTest

module.exports = config
