gulp = require("gulp")
$ = require("gulp-load-plugins")()
notify = require("gulp-notify")

paths =
  bower: "bower_components/"
  jquery: "bower_components/jquery/"
  bootstrap: "bower_components/bootstrap/"
  font_awesome: "bower_components/font-awesome/"
  sass: "assets/scss/"
  js: "assets/js/"
  img: "assets/img/"
  dist: "dist/"
  public: "public/"

autoprefixer = [
  "last 2 versions"
]

# Task for styles files
gulp.task "styles", [ "bower", "fonts" ], ->

  src = [
    paths.sass + "style.scss"
  ]

  gulp.src src
  .pipe $.sass()
    .on("error", notify.onError((err) ->
      "Check error(s) in console"
    ))
    .on("error", $.sass.logError)
  .pipe $.autoprefixer
    browsers: autoprefixer
  .pipe $.cssnano()
  .pipe $.concat "style.css"
  .pipe $.rename
    suffix: ".min"
  .pipe $.size()
  .pipe notify
      title: "SASS task"
      message: "Done"
  .pipe gulp.dest paths.public



# task for scripts files
gulp.task "scripts", [ "bower", "coffee" ], ->

  src = [
    paths.jquery + "dist/jquery.js",
    paths.js + "app.js"
  ]

  gulp.src src
  .pipe $.uglify()
    .on("error", notify.onError((err) ->
      "Check error(s) in console"
    ))
    .on("error", (err) ->
      console.log err
    )
  .pipe $.concat "app.js"
  .pipe $.rename
    suffix: ".min"
  .pipe notify
    title: "JavaScript task"
    message: "Done"
  .pipe gulp.dest paths.public


# Convert CoffeeScript to JavaScript
gulp.task "coffee", ->
  gulp.src(paths.js + "app.coffee")
  .pipe($.coffee())
  .pipe gulp.dest(paths.js)



# Copy fonts files and associated scss files
gulp.task 'fonts', ['bower'], ->
  gulp.src paths.font_awesome + 'fonts/**.*'
  .pipe gulp.dest paths.public + 'fonts'



# Cleaning dist directory
gulp.task 'clean', ->
  gulp.src ['dist', 'bower_components', 'vendor'],
    read: false
  .pipe $.clean
    force: true



# Copy images
gulp.task 'images', ->
  gulp.src paths.img + "**"
  .pipe imagemin
    progressive: true
  .pipe gulp.dest paths.public + "img"


# Convert Jade file to html
gulp.task "html", ->
  gulp.src "index.jade"
  .pipe $.jade
    pretty: true
  .pipe gulp.dest paths.dist

# execute bower
gulp.task "bower", ->
  $.bower()

# Watch task
gulp.task "watch", [ "default" ], ->
  gulp.watch paths.sass + "**", [ "styles" ]
  gulp.watch paths.js + "*.coffee", [ "scripts" ]

# Dafault task
gulp.task "default", [ "bower", "html", "styles", "scripts", "images" ], ->