config = require '../../dist/config'
chartpath = require '../../dist/common/chartpath'

chai = require 'chai'
chai.should()

describe 'chartpath', () ->
  it 'should return directory in "e2d3-contrib" repository on GitHub if it has no slash', () ->
    result = chartpath path: 'barchart'
    result.should.equal "#{config.fileBase}/github/e2d3/e2d3-contrib/contents/barchart"

  it 'should return root of user repository on GitHub if it has one slash', () ->
    result = chartpath path: 'foo/bar'
    result.should.equal "#{config.fileBase}/github/foo/bar/contents"

  it 'should return directory in user repository on GitHub if it has tow slashes', () ->
    result = chartpath path: 'foo/bar/baz'
    result.should.equal "#{config.fileBase}/github/foo/bar/contents/baz"

  it 'should return original if it has more than three slashes', () ->
    result = chartpath path: 'foo/bar/baz/qux'
    result.should.equal 'foo/bar/baz/qux'

  it 'should return original if it has schema string', () ->
    result = chartpath path: 'http://foo/bar'
    result.should.equal 'http://foo/bar'
