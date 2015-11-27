gulp = require('gulp')
jscs = require('gulp-jscs')
gutil = require('gulp-util')
batch = require('gulp-batch')
watch = require('gulp-watch')
coffee = require('gulp-coffee')
uglify = require('gulp-uglifyjs')
plumber = require('gulp-plumber')
sourcemaps = require('gulp-sourcemaps')
prettify = require('gulp-jsbeautifier')

scripts = 'lib/**/*.coffee';

gulp.task('build', function() {
    return gulp
        .src(scripts)
        .pipe(watch(scripts))
        .pipe(plumber())
        .pipe(sourcemaps.init())
        .pipe(coffee({bare: true}))
        .pipe(jscs({fix:true}))
        .pipe(prettify({
            js: {
                indentWithTabs: true,
                braceStyle: 'end-collapse'
            }
        }))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest('bin'));
})
gulp.task('watch', function() {
    watch(scripts, batch(function(events, done){
        gulp.start('build', done)
    }));
})
gulp.task('default', ['build', 'watch']);
