const gulp = require('gulp');
const pulp = require('./');

gulp.task('simple', (cb) => {
   console.log('simple gulp task');
   cb();
});

gulp.task('default', ['posh:simple']);
