gulp = require 'gulp'
gutil = require 'gulp-util'
sourcemaps = require 'gulp-sourcemaps'
uglify = require 'gulp-uglify'
source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
browserify = require 'browserify'
watchify = require 'watchify'
browserSync = require 'browser-sync'
assign = require('lodash').assign

paths =
  html: 'app/html/**/*.html'
  coffee:
    src: 'src/**/*.coffee'
    dest: 'app/scripts'
    entries: ['./src/main.coffee']

gulp.task 'coffee', ->
  customOpts =
    entries: paths.coffee.entries
    extensions: ['.coffee']
    debug: true
  opts = assign {}, watchify.args, customOpts
  bundle = watchify(browserify(opts)).bundle()

  logErrors = gutil.log.bind(gutil, gutil.colors.red.bold('Error'))

  bundle.on('error', logErrors)
    .pipe(source('bundle.min.js'))
    .pipe(buffer())
    .pipe(sourcemaps.init loadMaps: true)
      .pipe(uglify())
    .pipe(sourcemaps.write '.')
    .pipe(gulp.dest paths.coffee.dest)

gulp.task 'server', ['coffee'], ->
  browserSync server:
    baseDir: 'app'
    index: 'html/index.html'

gulp.task 'reload', ->
  browserSync.reload()

gulp.task 'reload-coffee', ['coffee'], ->
  browserSync.reload()

gulp.task 'watch', ->
  gulp.watch paths.html, ['reload']
  gulp.watch paths.coffee.src, ['reload-coffee']

gulp.task 'default', ['coffee', 'server', 'watch']
