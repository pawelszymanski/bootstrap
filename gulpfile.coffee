
gulp =   require 'gulp'
coffee = require 'gulp-coffee'
sass =   require 'gulp-sass'
haml =   require 'gulp-haml'
concat = require 'gulp-concat'



sources =
  docs:
    images:      './src/docs/images/**/*.{jpg, jpeg, png, gif,}'
    scripts:     './src/docs/scripts/**/*.coffee'
    stylesheets: './src/docs/stylesheets/docs.sass'
    webfonts:    './src/docs/webfonts/**/*.{eot, ttf, woff, svg}'
    pages:       './src/docs/**/*.haml'
  lib: 
    scripts:     './src/lib/scripts/**/*.coffee'
    stylesheets: './src/lib/stylesheets/lib.sass'
    templates:   './src/lib/templates/**/*.haml'
  vendor:
    scripts:
      jquery:      './vendor/scripts/jquery/'
      angular:     './vendor/scripts/angular/'

destinations =
  docs:
    images:      './dist/docs/images/'
    scripts:     './dist/docs/scripts/'
    stylesheets: './dist/docs/stylesheets/'
    webfonts:    './dist/docs/webfonts/'
    pages:       './dist/docs/'
  lib:
    scripts:     './dist/lib/scripts/'
    stylesheets: './dist/lib/stylesheets/'
    templates:   './disc/lib/templates/'
  vendor:
    scripts:     './dist/lib/scripts/'



gulp.task 'docs-images', ->
  gulp.src(sources.docs.images)
    .pipe(gulp.dest(destinations.docs.images))

gulp.task 'docs-scripts', ->
  gulp.src(sources.docs.scripts)
    .pipe(coffee())
    .pipe(gulp.dest(destinations.docs.scripts))

gulp.task 'docs-stylesheets', ->
  gulp.src(sources.docs.stylesheets)
    .pipe(sass())
    .pipe(gulp.dest(destinations.docs.stylesheets))

gulp.task 'docs-webfonts', ->
  gulp.src(sources.docs.webfonts)
    .pipe(gulp.dest(destinations.docs.webfonts))

gulp.task 'docs-pages', ->
  gulp.src(sources.docs.pages)
    .pipe(haml())
    .pipe(gulp.dest(destinations.docs.pages))

gulp.task 'lib-scripts', ->
  gulp.src(sources.lib.scripts)
    .pipe(coffee())
    .pipe(gulp.dest(destinations.lib.scripts))

gulp.task 'lib-stylesheets', ->
  gulp.src(sources.lib.stylesheets)
    .pipe(sass())
    .pipe(gulp.dest(destinations.lib.stylesheets))

gulp.task 'lib-templates', ->
  gulp.src(sources.lib.templates)
    .pipe(haml())
    .pipe(gulp.dest(destinations.lib.templates))

gulp.task 'vendor-scripts', ->
  gulp.src([sources.vendor.scripts.jquery, sources.vendor.scripts.angular])
    .pipe(concat('vendor.js'))
    .pipe(gulp.dest(destinations.vendor.scripts))



gulp.task 'build', [
  'vendor-scripts'
  'lib-scripts'
  'lib-stylesheets'
  'lib-templates'
  'docs-scripts'
  'docs-stylesheets'
  'docs-webfonts'
  'docs-images'
  'docs-pages'
]

gulp.task 'watch', ->
  gulp.watch sources.vendor.scripts.jquery, ['vendor-scripts']
  gulp.watch sources.vendor.scripts.angular, ['vendor-scripts']
  gulp.watch sources.lib.scripts, ['lib-scripts']
  gulp.watch sources.lib.stylesheets, ['lib-stylesheets']
  gulp.watch sources.lib.templates, ['lib-templates']
  gulp.watch sources.docs.scripts, ['docs-scripts']
  gulp.watch sources.docs.stylesheets, ['docs-stylesheets']
  gulp.watch sources.docs.webfonts, ['docs-webfonts']
  gulp.watch sources.docs.images, ['docs-images']
  gulp.watch sources.docs.pages, ['docs-pages']



gulp.task 'default', ['build', 'watch']
