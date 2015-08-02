Promise = require 'bluebird'

config = require 'config'

error = require 'error'
storage = require 'storage'
thumbnail = require 'storage/container/thumbnail'

chai = require 'chai'
chai.use require 'chai-as-promised'
chai.should()

PATH = 'ac42acf9/bd26de2c8c6baee1947306870f8d199b'
DATA = 'RTJEMyBpcyBFeGNlbCB0byBEMy5qcw=='

describe 'storage/container/thumbnail', () ->
  beforeEach () ->
    storage.clear()
      .then () ->

  describe '#exists()', ->
    it 'should return path if found', () ->
      thumbnail.put PATH, new Buffer(DATA, 'base64')
        .then (path) ->
          thumbnail.exists path
        .should.become PATH

    it 'should throw NotFoundError if not found', () ->
      thumbnail.exists('unknown').should.be.rejectedWith error.NotFoundError

  describe '#get()', ->
    it 'should return stored data', () ->
      thumbnail.put PATH, new Buffer(DATA, 'base64')
        .then (path) ->
          thumbnail.get path
        .should.become new Buffer(DATA, 'base64')

    it 'should throw NotFoundError if not found', () ->
      thumbnail.get('unknown').should.be.rejectedWith error.NotFoundError

  describe '#put()', ->
    it 'should return passed data', () ->
      thumbnail.put PATH, new Buffer(DATA, 'base64')
        .should.become PATH
