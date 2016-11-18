'use strict';

const run = require('child_process').spawnSync;
const spawn = require('child_process').spawn;
const gulp = require('gulp');

const switches = [
   '-NoProfile',
   '-NoLogo',
   '-NonInteractive',
   '-File'
];

module.exports = function (file) {
   const initResult = run('powershell', switches.concat(file)).stdout;
   const tasks = JSON.parse(initResult);
   Object.keys(tasks).forEach(function(key) {
      const cb = (cb) => {
         const execSwitches = switches.concat(file, key);
         const taskProcess = spawn('powershell', execSwitches, {stdio: ['inherit', 'pipe']});

         taskProcess.stdout.on('data', (data) => console.log(JSON.parse(data.toString())));

         taskProcess.on('close', () => cb());
      };
      gulp.task(key, tasks[key], cb);
   });
};