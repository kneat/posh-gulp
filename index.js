const run = require('child_process').spawnSync;
const spawn = require('child_process').spawn;
const split = require('split');
const parseString = require('xml2js').parseString;
const gulp = require('gulp');

const switches = [
   '-NoProfile',
   '-NoLogo',
   '-NonInteractive',
   '-File', './tasks.ps1'
];

function readTasks(cb) {
   let result = run('powershell', switches).stdout;
   let data = result.toString();
   let tasks = JSON.parse(result);
   cb(tasks);
}

readTasks(function(tasks){
   Object.keys(tasks).forEach(function(key) {
      let cb = (cb) => {         
         var execSwitches = switches.concat(key);
         var taskProcess = spawn('powershell', execSwitches);
         taskProcess.stdout.pipe(process.stdout);
         taskProcess.on('close', () => cb());
      }
      gulp.task(key, tasks[key], cb);
   });
});