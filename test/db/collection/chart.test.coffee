config = require 'config'

error = require 'error'
db = require 'db'
charts = require 'db/collection/chart'

chai = require 'chai'
chai.use require 'chai-as-promised'
chai.should()

HASH_FOO = 'ac42acf9bd26de2c8c6baee1947306870f8d199b8e2c8ad9974e7529df4f739b'
HASH_BAR = 'e6650f6fef07220443d66b74a1d2e85399df1c45a6305e15928447e8d2f7580b'

FOO =
  path: 'foo'
  revision: '0000000'
  type: 'js'

BAR =
  path: 'bar'
  revision: '0000000'
  type: 'js'

describe 'db/collection/chart', () ->
  beforeEach () ->
    db.clear()
      .then () ->
        charts.put FOO

  describe '#get()', ->
    it 'should return stored data', () ->
      charts.get(HASH_FOO).should.become
        id: HASH_FOO
        path: 'foo'
        revision: '0000000'
        type: 'js'

    it 'should throw NotFoundError if not found', () ->
      charts.get('unknown').should.be.rejectedWith error.NotFoundError

    it 'should work with abbreviated id', () ->
      charts.get(HASH_FOO[0...32]).should.become
        id: HASH_FOO
        path: 'foo'
        revision: '0000000'
        type: 'js'

  describe '#put()', ->
    it 'should return id', () ->
      charts.put(BAR).should.become HASH_BAR

    it 'should return id if upsert', () ->
      charts.put(FOO).should.become HASH_FOO
