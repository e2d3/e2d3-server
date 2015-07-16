Promise = require 'bluebird'

config = require '../../../../dist/config'

common = require '../../../../dist/common'
queue = require '../../../../dist/common/queue'
thumbnail = require '../../../../dist/common/queue/kind/thumbnail'

chai = require 'chai'
chai.use require 'chai-as-promised'
chai.should()

describe 'data', () ->
  beforeEach () ->
    queue.clear()
      .then () ->

  describe '#get()', ->
    it 'should return posted data', () ->
      thumbnail.post
        path: 'foo'
        revision: '0000000'
        type: 'js'
      .then () ->
        thumbnail.get()
      .then (message) ->
        Promise.resolve message.value()
      .should.become
        path: 'foo'
        revision: '0000000'
        type: 'js'

    it 'should throw NotAvailableError if queue is empty', () ->
      thumbnail.get().should.be.rejectedWith common.NotAvailableError

  describe '#post()', ->
    it 'should return passed data', () ->
      thumbnail.post
        path: 'foo'
        revision: '0000000'
        type: 'js'
      .should.become
        path: 'foo'
        revision: '0000000'
        type: 'js'
