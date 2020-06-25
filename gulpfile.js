const gulp = require('gulp');
const pulp = require('./');

gulp.task('build', cb => {
   console.log('building');
   cb();
});

pulp(gulp, './tasks.ps1');

gulp.task('default', gulp.series('posh:simple'));