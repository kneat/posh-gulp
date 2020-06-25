'use strict';

const run = require('child_process').spawnSync;
const spawn = require('child_process').spawn;
const colors = require('ansi-colors');
const log = require('fancy-log');
const args = require('yargs').argv;


const switches = [
   '-NoProfile',
   '-NoLogo',
   '-NonInteractive',
   '-File'
];

module.exports = function (gulp, file) {

   log('Importing Tasks', colors.magenta(file));

   const result = run('powershell', switches.concat(file));

   if (result.stderr.length > 0)
      log.error(result.stderr.toString());
   else {
      const tasks = JSON.parse(result.stdout);
      Object.keys(tasks).forEach(function (key) {
         gulp.task(key, gulp.series(tasks[key], () => {
            const execSwitches = switches.concat(file, key);
            const taskProcess = spawn('powershell', execSwitches, { stdio: ['inherit', 'pipe'] });

            const taskLabel = colors.cyan(key);

            taskProcess.stdout.on('data', data => {
               data
                  .toString()
                  .split(/\r?\n/)
                  .filter(l => l !== '')
                  .map(l => JSON.parse(l))
                  .forEach(l => {
                     switch (l.level)
                     {
                        case 'debug':
                           args.verbose && log.info(taskLabel, l.message);
                           break;
                        case 'verbose':
                           args.verbose && log.info(taskLabel, l.message);
                           break;
                        case 'information':
                           log.info(taskLabel, l.message);
                           break;
                        case 'warning':
                           log.warn(taskLabel, l.message);
                           break;
                        case 'error':
                           log.error(taskLabel, l.message);
                           break;
                        default:
                           log(taskLabel, l.message);
                     }
                  });
            });

            return taskProcess;
         }));
      });
   }
};