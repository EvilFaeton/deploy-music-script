var gulp = require('gulp'),
  coffee = require('gulp-coffee'),
  uglify = require('gulp-uglify'),
  clean  = require('gulp-clean'),
  gutil  = require('gulp-util');

gulp.task('src', function(){
  return gulp.src('src/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(uglify())
    .pipe(gulp.dest('lib'));
});

gulp.task('clean', function() {
  return gulp.src(['lib'], {read: false}).pipe(clean());
});

gulp.task('default', ['clean'], function() {
    gulp.start('src');
});

gulp.task('watch', function() {
  gulp.watch('src/*.coffee', ['src']);
});
