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

const powershellCommand = 'powershell';
const pwshCommand = 'pwsh';

const getPowershellCommand = (options) => {
  if (options.runOnWindowsPowershell || !commandExists(pwshCommand)) {
     return powershellCommand;
  }
  
  return pwshCommand;
};

module.exports = function (gulp, file, options = { runOnWindowsPowershell: false }) {
   const powershellCommand = getPowershellCommand(options);
   
   if (!commandExists(powershellCommand)) {
      console.error(`Command ${powershellCommand} not found. Please make sure it is installed and accessible through the PATH envvar.`);
      process.exit(1);
   }

   log(`Importing Tasks using ${powershellCommand}`, colors.magenta(file));

   const result = run(powershellCommand, switches.concat(file));
   const debugOrVerbose = (args.debug || args.verbose);

   if (result.error || result.stderr && result.stderr.length > 0)
      log.error(result.error || result.stderr.toString());
   else {
      const tasks = JSON.parse(result.stdout);
      Object.keys(tasks).forEach(function (key) {
         const task = () => {
            const execSwitches = switches.concat(file, key, process.argv);
            const taskProcess = spawn(powershellCommand, execSwitches, { stdio: ['inherit', 'pipe', 'inherit'] });
            const taskLabel = colors.cyan(key);

            taskProcess.stdout.on('data', data => {
               data
                  .toString()
                  .split(/\r?\n/)
                  .filter(l => l !== '')
                  .map(lineAsJson)
                  .forEach(l => logForLevel(l, taskLabel, debugOrVerbose));
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

function logForLevel(l, taskLabel, debugOrVerbose) {
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
         // this should use log.warn(), but for some reason when called via gulp and level is warning, stderr seems to be suppressed
         log.info(taskLabel, l.message);
         break;
      case 'error':
         log.error(taskLabel, l.message);
         break;
      default:
         log(taskLabel, l.message);
   }
}