config = require 'config'
chartpath = require 'chartpath'

chai = require 'chai'
chai.should()

describe 'chartpath', () ->
  describe '#encode()', () ->
    it 'should return directory in "e2d3-contrib" repository on GitHub if it has no slash', () ->
      result = chartpath.encode "#{config.apiBase}/files/github/e2d3/e2d3-contrib/contents/barchart"
      result.should.equal 'barchart'

    it 'should return root of user repository on GitHub if it has one slash', () ->
      result = chartpath.encode "#{config.apiBase}/files/github/foo/bar/contents"
      result.should.equal 'foo/bar'

    it 'should return directory in user repository on GitHub if it has tow slashes', () ->
      result = chartpath.encode "#{config.apiBase}/files/github/foo/bar/contents/baz"
      result.should.equal 'foo/bar/baz'

    it 'should return Gist if it is with "gist:" schema', () ->
      result = chartpath.encode "#{config.apiBase}/files/gists/00000000"
      result.should.equal 'gist:00000000'

    it 'should return delegated contents if it is with "delegate:" schema', () ->
      result = chartpath.encode 'https://localhost:8443/files/github/e2d3/e2d3-contrib/contents/barchart'
      result.should.equal 'delegate:barchart'

    it 'should return original if it has more than three slashes', () ->
      result = chartpath.encode 'foo/bar/baz/qux'
      result.should.equal 'foo/bar/baz/qux'

    it 'should return original if it has schema string', () ->
      result = chartpath.encode 'http://foo/bar'
      result.should.equal 'http://foo/bar'

  describe '#decode()', () ->
    it 'should return directory in "e2d3-contrib" repository on GitHub if it has no slash', () ->
      result = chartpath.decode 'barchart'
      result.should.equal '/files/github/e2d3/e2d3-contrib/contents/barchart'

    it 'should return root of user repository on GitHub if it has one slash', () ->
      result = chartpath.decode 'foo/bar'
      result.should.equal '/files/github/foo/bar/contents'

    it 'should return directory in user repository on GitHub if it has tow slashes', () ->
      result = chartpath.decode 'foo/bar/baz'
      result.should.equal '/files/github/foo/bar/contents/baz'

    it 'should return Gist if it is with "gist:" schema', () ->
      result = chartpath.decode 'gist:00000000'
      result.should.equal '/files/gists/00000000'

    it 'should return delegated contents if it is with "delegate:" schema', () ->
      result = chartpath.decode 'delegate:barchart'
      result.should.equal 'https://localhost:8443/files/github/e2d3/e2d3-contrib/contents/barchart'

    it 'should return original if it has more than three slashes', () ->
      result = chartpath.decode 'foo/bar/baz/qux'
      result.should.equal 'foo/bar/baz/qux'

    it 'should return original if it has schema string', () ->
      result = chartpath.decode 'http://foo/bar'
      result.should.equal 'http://foo/bar'

  describe '#decodeWithBase()', () ->
    it 'should return directory in "e2d3-contrib" repository on GitHub if it has no slash', () ->
      result = chartpath.decodeWithBase 'barchart'
      result.should.equal "#{config.apiBase}/files/github/e2d3/e2d3-contrib/contents/barchart"

    it 'should return root of user repository on GitHub if it has one slash', () ->
      result = chartpath.decodeWithBase 'foo/bar'
      result.should.equal "#{config.apiBase}/files/github/foo/bar/contents"

    it 'should return directory in user repository on GitHub if it has tow slashes', () ->
      result = chartpath.decodeWithBase 'foo/bar/baz'
      result.should.equal "#{config.apiBase}/files/github/foo/bar/contents/baz"

    it 'should return Gist if it is with "gist:" schema', () ->
      result = chartpath.decodeWithBase 'gist:00000000'
      result.should.equal "#{config.apiBase}/files/gists/00000000"

    it 'should return delegated contents if it is with "delegate:" schema', () ->
      result = chartpath.decode 'delegate:barchart'
      result.should.equal 'https://localhost:8443/files/github/e2d3/e2d3-contrib/contents/barchart'

    it 'should return original if it has more than three slashes', () ->
      result = chartpath.decodeWithBase 'foo/bar/baz/qux'
      result.should.equal 'foo/bar/baz/qux'

    it 'should return original if it has schema string', () ->
      result = chartpath.decodeWithBase 'http://foo/bar'
      result.should.equal 'http://foo/bar'
