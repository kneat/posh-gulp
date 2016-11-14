Ever wanted to implement your gulp task direclty with powershell?

Tasks
-----
### `gulpfile.js`

```js
const gulp = require('gulp');
const pulp = require('posh-gulp');

pulp('./gulpfile.ps1');

gulp.task('build', (cb) => {
   console.log('building');
   cb();
});

gulp.task('default', ['posh:simple']);
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

Logging
-------
A utility module is also available to clean up logging.

### `Write-Gulp`
Replace `Write-Host` with `Write-Gulp` to get time stamped output similar to
`gulp-utils` log function.

```ps
Import-Module ./path-to-posh-gulp/Logger

Add-Task "logging" @() {
    'simple powershell task' | Write-Gulp 
    Write-Gulp -IncludeName 'some more output prefixed with task'
}
```

```
[23:17:08] Starting 'loggging'...
[23:17:09] some output
[23:17:09] logging some more output prefixed with task
[23:17:09] Finished 'loggging' after 723 ms
```

Development
===========
Run powershell tests with pester (choco install):
```powershell
Invoke-Pester
```
