// lib
const semver = require('semver');
const fs = require('fs');
const path = require('path');

// helpers
const {areVersionsValid} = require('./helpers');

// args
const [master, branch] = process.argv.slice(2, 4);
const packageJsonPath = path.resolve('./package.json');
const packageJson = require(packageJsonPath);



// check validity
if(!areVersionsValid(master, branch)) {
  process.exit();
}

// if master < branch, do nothing
if(semver.lt(master, branch)) {
  console.log('branch_higher');
  process.exit();
}


// bump up the version
packageJson.version = semver.inc(master, 'patch');

// attempt to save
fs.writeFile(packageJsonPath, JSON.stringify(packageJson, null, 2), (err) => {
  if (err) {
    console.log('save_failed', err);
    process.exit();
  }

  console.log(`success:${semver.inc(master, 'patch')}`);
  process.exit();
});


