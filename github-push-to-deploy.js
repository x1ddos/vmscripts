#!/usr/bin/env node
var UPDATE_CMD = '/apps/bin/update.sh';

var fs = require('fs'),
    proc = require('child_process');

var payload;
try {
    payload = JSON.parse(fs.readFileSync('/dev/stdin'));
} catch(err) {
    process.stdout.write('Status: 400\nContent-Type: text/plain\n\n' + err.toString() + '\n');
    process.exit(0);
}

if (!payload.ref || !payload.ref.match(/^refs\/heads\/master$/i)) {
    process.stdout.write('Status: 200\nContent-Type: text/plain\n\nSkip update: not master branch\n');
    process.exit(0);
}

var args = ['-u', 'apps', UPDATE_CMD, payload.repository.name, payload.repository.url];
proc.execFile('sudo', args, {}, function(err, stdout, stderr) {
    var resp = 'Status: ' + (err ? 500 : 200) + '\nContent-Type: text/plain\n\n';
    resp += '\n>>> STDOUT:\n' + stdout + '\n\n>>> STDERR:\n' + stderr;
    process.stdout.write(resp);
});
