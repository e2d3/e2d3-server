gulp = require 'gulp'
gutil = require 'gulp-util'
debug = require 'gulp-debug'
chug = require 'gulp-chug'

rimraf = require 'rimraf'
merge = require 'merge2'

cond = require 'gulp-if'
filter = require 'gulp-filter'

server = require 'gulp-develop-server'
plumber = require 'gulp-plumber'
sourcemaps = require 'gulp-sourcemaps'

coffee = require 'gulp-coffee'

mocha = require 'gulp-mocha'

isRelease = gutil.env.release?
isFirst = true

e2d3args = if isRelease then ['--release'] else []

gulp.task 'clean', (cb) ->
  if isFirst
    isFirst = false
    rimraf 'dist', cb
  else
    cb()

gulp.task 'js', ['clean'], () ->
  gulp.src 'src/**/*.js'
    .pipe gulp.dest 'dist'

gulp.task 'coffee', ['clean'], () ->
  gulp.src 'src/**/*.coffee'
    .pipe plumber()
    .pipe sourcemaps.init()
    .pipe coffee()
    .pipe sourcemaps.write()
    .pipe gulp.dest 'dist'

gulp.task 'jade', ['clean'], () ->
  gulp.src 'src/**/*.jade'
    .pipe gulp.dest 'dist'

gulp.task 'scripts', ['js', 'coffee', 'jade']

gulp.task 'build', ['scripts'], () ->
  if process.argv.indexOf('build') != -1
    gulp.src 'e2d3/gulpfile.coffee'
      .pipe coffee()
      .pipe chug tasks: ['build'], args: e2d3args

gulp.task 'test', ['build'], () ->
  gulp.src 'test/**/*.coffee', read: false
    .pipe plumber()
    .pipe mocha()
    .once 'error', (e) ->
      if e.domainEmitter?
        process.exit 1

gulp.task 'watch', ['test'], ->
  gulp.watch ['src/**/*', 'test/**/*'], ['test']
  gulp.watch ['dist/**/*', 'e2d3/dist/**/*', 'server.js'], notifyLivereload

gulp.task 'run', ['watch'], () ->
  gulp.src 'e2d3/gulpfile.coffee'
    .pipe coffee()
    .pipe chug tasks: ['watch-server'], args: e2d3args

  startExpress()
  startLivereload()

gulp.task 'default', ['build']

startExpress = () ->
  server.listen path: 'server.js'

lr = null
startLivereload = () ->
  lr = (require 'tiny-lr')()
  lr.listen 35729

notifyLivereload = (event) ->
  server.restart (error) ->
    if !error
      lr.changed body: files: ['dummy']
