// lib
const semver = require('semver');


exports.areVersionsValid = (master, branch) => {
  let isError = false;


  if (!semver.valid(master)) {
    console.log('master_invalid');
    isError = true;
  }

  if (!semver.valid(branch)) {
    console.log('branch_invalid');
    isError = true;
  }


  return !isError;
};
