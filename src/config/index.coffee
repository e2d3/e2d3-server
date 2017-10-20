config =
  switch process.env.NODE_ENV
    when 'production'
      isInDevelopment: false
      domainApi: 'a.e2d3.org'
      domainShare: 's.e2d3.org'
      apiBase: 'https://a.e2d3.org'
      dataBase: 'https://s.e2d3.org/data'
      shareBase: 'https://s.e2d3.org'
      thumbnailBase: 'https://t.e2d3.org/thumbnails'
      corsOrigin: 'https://s.e2d3.org'
      databaseType: 'azure'
      queueType: 'azure'
      storageType: 'azure'
    when 'staging'
      isInDevelopment: false
      domainApi: 'as.e2d3.org'
      domainShare: 'ss.e2d3.org'
      apiBase: 'http://as.e2d3.org'
      dataBase: 'http://ss.e2d3.org/data'
      shareBase: 'http://ss.e2d3.org'
      thumbnailBase: 'http://ts.e2d3.org/thumbnails'
      corsOrigin: 'http://ss.e2d3.org'
      databaseType: 'azure'
      queueType: 'azure'
      storageType: 'azure'
    when 'testing'
      isInDevelopment: false
      domainApi: 'at.e2d3.org'
      domainShare: 'st.e2d3.org'
      apiBase: 'http://at.e2d3.org'
      dataBase: 'http://st.e2d3.org/data'
      shareBase: 'http://st.e2d3.org'
      thumbnailBase: 'http://tt.e2d3.org/thumbnails'
      corsOrigin: 'http://st.e2d3.org'
      databaseType: 'azure'
      queueType: 'azure'
      storageType: 'azure'
    else
      isInDevelopment: true
      domainApi: 'ad.e2d3.org'
      domainShare: 'sd.e2d3.org'
      apiBase: 'http://ad.e2d3.org:8000'
      dataBase: 'http://sd.e2d3.org:8000/data'
      shareBase: 'http://sd.e2d3.org:8000'
      thumbnailBase: 'http://td.e2d3.org:8000/thumbnails'
      corsOrigin: 'http://sd.e2d3.org:8000'
      databaseType: 'redis'
      queueType: 'redis'
      storageType: 'redis'

config.cacheAgeStatic = 10 * 60 * 1000 # 10 min
config.cacheAgeGitHub = 10 * 60 * 1000 # 10 min

config.isInTest = typeof global.it == 'function'
if config.isInTest
  config.databaseType = 'mock'
  config.queueType = 'mock'
  config.storageType = 'mock'

module.exports = config
