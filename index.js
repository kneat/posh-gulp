'use strict';

const run = require('child_process').spawnSync;
const spawn = require('child_process').spawn;
const colors = require('ansi-colors');
const log = require('fancy-log');
const args = require('yargs').argv;
const commandExists = require('command-exists').sync;

const switches = [
   '-NoProfile',
   '-NoLogo',
   '-NonInteractive',
   '-File'
]; 

module.exports = function (gulp, file, options = { runOnWindowsPowershell: false }) {

   log('Importing Tasks', colors.magenta(file));

   const powershellCommand = !options.runOnWindowsPowershell && commandExists('pwsh') ? 'pwsh' : 'powershell';

   const result = run(powershellCommand, switches.concat(file));

   if (result.stderr.length > 0)
      log.error(result.stderr.toString());
   else {
      const tasks = JSON.parse(result.stdout);
      Object.keys(tasks).forEach(function (key) {
         const task = () => {
            const execSwitches = switches.concat(file, key, process.argv);
            const taskProcess = spawn(powershellCommand, execSwitches, { stdio: ['inherit', 'pipe', 'inherit'] });
            const taskLabel = colors.cyan(key);
            const debugOrVerbose = (args.debug || args.verbose);

            taskProcess.stdout.on('data', data => {
               data
                  .toString()
                  .split(/\r?\n/)
                  .filter(l => l !== '')
                  .map(lineAsJson)
                  .forEach(l => {
                     switch (l.level)
                     {
                        case 'debug':
                           debugOrVerbose && log.info(taskLabel, l.message);
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
         };

         task.displayName = `${key} powershell task`;
         gulp.task(key, gulp.series(tasks[key], task));
      });
   }
};

function lineAsJson(line) {
   try{
      return JSON.parse(line)
   } catch {
      return {
         level: 'unknown',
         message: line
      };
   }
}
