config =
  switch process.env.NODE_ENV
    when 'production'
      isInDevelopment: false
      domainApi: 'a.e2d3.org'
      domainShare: 's.e2d3.org'
      fileBase: 'https://a.e2d3.org/files'
      dataBase: 'https://s.e2d3.org/data'
      shareBase: 'https://s.e2d3.org'
      corsOrigin: 'https://s.e2d3.org'
      databaseType: 'azure'
      queueType: 'azure'
      storageType: 'azure'
    when 'staging'
      isInDevelopment: false
      domainApi: 'as.e2d3.org'
      domainShare: 'ss.e2d3.org'
      fileBase: 'http://as.e2d3.org/files'
      dataBase: 'http://ss.e2d3.org/data'
      shareBase: 'http://ss.e2d3.org'
      corsOrigin: 'http://ss.e2d3.org'
      databaseType: 'azure'
      queueType: 'azure'
      storageType: 'azure'
    when 'testing'
      isInDevelopment: false
      domainApi: 'at.e2d3.org'
      domainShare: 'st.e2d3.org'
      fileBase: 'http://at.e2d3.org/files'
      dataBase: 'http://st.e2d3.org/data'
      shareBase: 'http://st.e2d3.org'
      corsOrigin: 'http://st.e2d3.org'
      databaseType: 'azure'
      queueType: 'azure'
      storageType: 'azure'
    else
      isInDevelopment: true
      domainApi: 'ad.e2d3.org'
      domainShare: 'sd.e2d3.org'
      fileBase: 'http://ad.e2d3.org:8000/files'
      dataBase: 'http://sd.e2d3.org:8000/data'
      shareBase: 'http://sd.e2d3.org:8000'
      corsOrigin: 'http://sd.e2d3.org:8000'
      databaseType: 'redis'
      queueType: 'redis'
      storageType: 'mock'

config.isInTest = typeof global.it == 'function'
if config.isInTest
  config.databaseType = 'mock'
  config.queueType = 'mock'
  config.storageType = 'mock'

module.exports = config
