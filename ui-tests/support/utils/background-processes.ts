import { spawn, exec } from 'child_process';
const rp = require('request-promise');
const limit = 60;
const cmd = process.platform.includes('win') ? 'npm.cmd' : 'npm';
const fp = require('find-process');

export let ownProcess = {

  getProcessPids(processNameOrPort: string | RegExp | number) {
    const findBy = typeof processNameOrPort === 'number' ? 'port' : 'name';

    return fp(findBy, processNameOrPort)
      .then((list) => list.map(process => process.pid), (error) => console.log(error));
    },

  async killAllHungProcesses(pidsBeforeExecution, pidsAfterExecution) {
    const hungProcesses = pidsAfterExecution.filter(pid => !pidsBeforeExecution.includes(pid));
    console.log(`processes ${hungProcesses} to be killed`);
    await hungProcesses.map((pid) => {
        try {
          process.kill(pid);
          console.log(`${pid} is killed`);
        } catch (err) {
          console.log(`${pid} is already declined`);
        }
    });
  },

  waitPort(n, port, callback) {
    exec('PowerShell -Command "&' +
      `{&"netstat" -ano | Select-String "${port}" | % {$a = $_ -split ' {3,}'; ` +
      `New-Object 'PSObject' -Property @{Original=$_;Fields=$a}} | ` +
      `? {$_.Fields[1] -match '${port}$'}}"`, (error, stdout, stderr) => {
      if (error) {
        console.error(`exec error: ${error}`);
        return;
      }
      if (stdout || n > limit) {
        callback();
      } else {
        setTimeout(() => {
          this.waitPort(n + 1, port, callback);
        }, 1000);
      }
    });
  },

  waitResp(n, url) {
    return rp(url)
      .then((resp) => {
        return;
      })
      .catch((err) => {
      if (n < limit) {
        return new Promise((resolve, reject) => {
          setTimeout(() => {
            resolve(this.waitResp(n + 1, url));
          }, 1000);
        });
      }
      });
  },

  webdriverManagerStart() {
    const wd = spawn(cmd, ['run', 'wd-start']);
    wd.stdout.on('data', function() {});
    wd.stderr.on('data', function() {});
    wd.on('exit', function() {
      console.log('WD shut down');
    });
    wd.stdin.end();
    return new Promise((resolve, reject) => {
      this.waitPort(0, '4444', resolve);
    });
  },

  runApp() {
    const appPr = spawn(cmd, ['run', 'start']);
    appPr.stdout.on('data', function(data) {
      console.log('Server Data: ' + data);
    });
    appPr.stderr.on('data', function() {});
    appPr.on('exit', function() {
      console.log('Server Script finished');
    });
    appPr.stdin.end();
    return new Promise((resolve, reject) => {
      this.waitPort(0, '4200', resolve);
    })
      .then(() => {
        return this.waitResp(0, 'http://localhost:4200/');
      });
  },

  wdStop() {
    return new Promise((resolve, reject) => {
      exec('npm run wd-stop', resolve);
    });
  },

  appStop() {
    return new Promise((resolve, reject) => {
      exec('npm run stop', resolve);
    });
  }
};

