const gulp = require('gulp');
const pulp = require('./');

pulp(gulp, './tasks.ps1');

gulp.task('build', (cb) => {
   console.log('building');
   cb();
});

gulp.task('default', ['posh:simple']);