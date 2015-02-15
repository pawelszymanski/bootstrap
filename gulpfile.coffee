gulp =   require 'gulp'
haml =   require 'gulp-ruby-haml'
sass =   require 'gulp-sass'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'



gulp.task 'scripts-bootstrap', ->
  gulp.src(['./src/scripts/bootstrap/**/*.coffee'])
    .pipe(concat('bootstrap.coffee'))
    .pipe(coffee())
    .pipe(gulp.dest('./dist/scripts/'))

gulp.task 'scripts-docs', ->
  gulp.src(['./src/scripts/docs/**/*.coffee'])
    .pipe(concat('docs.coffee'))
    .pipe(coffee())
    .pipe(gulp.dest('./dist/scripts/'))

gulp.task 'scripts-vendor', ->
  gulp.src(['./src/scripts/vendor/**/*.js'])
    .pipe(gulp.dest('./dist/scripts/vendor/'))

gulp.task 'stylesheets-bootstrap', ->
  gulp.src(['./src/stylesheets/bootstrap.sass'])
    .pipe(gulp.dest('./dist/stylesheets/'))
  gulp.src(['./src/stylesheets/bootstrap/**/*.sass'])
    .pipe(gulp.dest('./dist/stylesheets/bootstrap/'))

gulp.task 'stylesheets-docs', ->
  gulp.src(['./src/stylesheets/docs.sass'])
    .pipe(sass())
    .pipe(gulp.dest('./dist/stylesheets/'))

gulp.task 'views-bootstrap', ->
  gulp.src(['./src/views/bootstrap/**/*.haml'])
    .pipe(haml())
    .pipe(gulp.dest('./dist/templates/bootstrap/'))

gulp.task 'views-docs', ->
  gulp.src(['./src/views/docs/docs.haml'])
    .pipe(haml())
    .pipe(gulp.dest('./dist/'))

gulp.task 'build', [
  'scripts-bootstrap'
  'scripts-docs'
  'scripts-vendor'
  'stylesheets-bootstrap'
  'stylesheets-docs'
  'views-bootstrap'
  'views-docs'
]

gulp.task 'watch', ->
  gulp.watch(['./src/scripts/bootstrap/**/*.coffee'], ['scripts-bootstrap'])
  gulp.watch(['./src/scripts/docs/**/*.coffee'], ['scripts-docs'])
  gulp.watch(['./src/scripts/vendor/**/*.js'], ['scripts-vendor'])
  gulp.watch(['./src/stylesheets/bootstrap.sass', './src/stylesheets/bootstrap/**/*.sass'], ['stylesheets-bootstrap'])
  gulp.watch(['./src/stylesheets/docs.sass'], ['stylesheets-docs'])
  gulp.watch(['./src/views/bootstrap/**/*.haml'], ['views-bootstrap'])
  gulp.watch(['./src/views/docs/docs.haml'], ['views-docs'])



gulp.task 'default', ['build', 'watch']
