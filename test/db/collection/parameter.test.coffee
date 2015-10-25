config = require 'config'

error = require 'error'
db = require 'db'
parameters = require 'db/collection/parameter'

chai = require 'chai'
chai.use require 'chai-as-promised'
chai.should()

HASH_FOO = '5e40e8538ba5abeaa65505da7a016bf4dee5d72b56e736f539ee503c196eb8d8'
HASH_BAR = '6889636478ac9c33ad4da8815cb37237bb27f0493112e3d886025e3a5990fb3d'

FOO =
  colors: ['#000000', '#ffffff']
  state:
    year: '2015'

BAR =
  colors: ['#000000', '#ff0000']
  state:
    year: '2001'

describe 'db/collection/chart', () ->
  beforeEach () ->
    db.clear()
      .then () ->
        parameters.put FOO

  describe '#get()', ->
    it 'should return stored data', () ->
      parameters.get(HASH_FOO).should.become
        colors: ['#000000', '#ffffff']
        state:
          year: '2015'

    it 'should throw NotFoundError if not found', () ->
      parameters.get('unknown').should.be.rejectedWith error.NotFoundError

    it 'should work with abbreviated id', () ->
      parameters.get(HASH_FOO[0...32]).should.become
        colors: ['#000000', '#ffffff']
        state:
          year: '2015'

  describe '#put()', ->
    it 'should return id', () ->
      parameters.put(BAR).should.become HASH_BAR

    it 'should return id if upsert', () ->
      parameters.put(FOO).should.become HASH_FOO
