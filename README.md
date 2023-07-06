Ever wanted to implement your gulp task directly with powershell?

Tasks
-----
### `gulpfile.js`

```js
const gulp = require('gulp');
const pulp = require('posh-gulp');

gulp.task('build', (cb) => {
   console.log('building');
   cb();
});

pulp(gulp, './gulpfile.ps1');

gulp.task('default', gulp.series('posh:simple'));
```

### `gulpfile.ps1`

```powershell
Import-Module ./path-to-posh-gulp/Gulp

Add-Task "posh:empty"

Add-Task "posh:simple" ("build", "posh:empty") {
    Write-Host 'simple powershell task'
}

Publish-Tasks $args
```

### Output
```
Importing Tasks ./gulpfile.ps1
Using gulpfile [...]/gulpfile.js
Starting 'build'...
building
Finished 'build'
Starting 'posh:empty'...
Finished 'posh:empty'
Starting 'posh:simple'...
simple powershell task
Finished 'posh:simple'
Starting 'default'...
Finished 'default'
```

Development
===========

Run powershell tests with pester (choco install):

```powershell
Invoke-Pester
```
