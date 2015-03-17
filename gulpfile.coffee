gulp = require 'gulp'
gutil = require 'gulp-util'
debug = require 'gulp-debug'
chug = require 'gulp-chug'

rimraf = require 'rimraf'

cond = require 'gulp-if'
filter = require 'gulp-filter'

server = require 'gulp-develop-server'
plumber = require 'gulp-plumber'
sourcemaps = require 'gulp-sourcemaps'

coffee = require 'gulp-coffee'

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
  gulp.src 'src/api/**/*.coffee'
    .pipe plumber()
    .pipe sourcemaps.init()
    .pipe coffee()
    .pipe sourcemaps.write()
    .pipe gulp.dest 'dist'

gulp.task 'build', ['js'], () ->
  if process.argv.indexOf('build') != -1
    gulp.src 'e2d3/gulpfile.coffee'
      .pipe coffee()
      .pipe chug tasks: ['build'], args: e2d3args

gulp.task 'watch', ['build'], ->
  gulp.watch 'src/api/**/*', ['js']
  gulp.watch 'dist/**/*', notifyLivereload
  gulp.watch 'e2d3/dist/**/*', notifyLivereload

gulp.task 'run', ['watch'], () ->
  gulp.src 'e2d3/gulpfile.coffee'
    .pipe coffee()
    .pipe chug tasks: ['watch'], args: e2d3args

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
