config = require '../../../../dist/config'

common = require '../../../../dist/common'
db = require '../../../../dist/common/db'
data = require '../../../../dist/common/db/collection/data'

chai = require 'chai'
chai.use require 'chai-as-promised'
chai.should()

HASH_FOO = '2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae'
HASH_BAR = 'fcde2b2edba56bf408601fb721fe9b5c338d10ee429ea04fae5511b68fbf8fb9'

describe 'data', () ->
  beforeEach () ->
    db.clear()
      .then () ->
        data.put 'foo'

  describe '#get()', ->
    it 'should return stored data', () ->
      data.get(HASH_FOO).should.become 'foo'

    it 'should throw NotFoundError if not found', () ->
      data.get('unknown').should.be.rejectedWith common.NotFoundError

    it 'should work with abbreviated id', () ->
      data.get(HASH_FOO[0...7]).should.become 'foo'

  describe '#put()', ->
    it 'should return id', () ->
      data.put('bar').should.become HASH_BAR

    it 'should return id if upsert', () ->
      data.put('foo').should.become HASH_FOO
