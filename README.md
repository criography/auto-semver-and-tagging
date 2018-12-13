# Dependencies
1. [Husky](https://github.com/typicode/husky) — npm package for better and easier handling of git hooks (devDependencies)
1. [semver-tool](https://github.com/fsaintjacques/semver-tool) — bash script for semver processing (preinstalled in `.scripts/vendor` dir)



# Automated semver
Proof of concept using `post-commit` hook to update `version` in `package.json`. 

#### Requirements
1. Ensure `Husky` package is available by running `npm i`.

#### Usage:
1. Create a new branch and perform whatever work in it.
1. Commit and push your work as usual.
1. Observe the "magic" (ie. additional commit).   
<img src="https://media.giphy.com/media/5sgppAtcWgPhS/giphy-downsized.gif" width="400" alt="clearly not magic" />

#### Script steps:
1. If current branch is master, exit early
1. Otherwise, fetch origin master, to ensure latest `package.json`
1. Extract semvers from `package.json`s (local branch's and the latest remote master's).
1. If branch is already greater than master, assume manual bump (e.g. for minor and major releases) or earlier run of this script and exit.
1. Otherwise, calculate the new semver (patch level) using latest remote master as a base.
1. Update the `package.json`
1. Create "magical" commit

#### Notes
1. While I was hoping this could be achieved in `pre-push` hook, it turns out it's triggered after the remote 
refs have been updated but before any objects have been transferred. Creating additional commits at this point is 
possible, but requires cancelling original push and triggering a separate one from the hook, which confuses git and results in an error. Although it works, it's hardly great dev experience.

1. This script compares semvers from `package.json`s only, which should be sufficient if everybody manages 
them and tags via these scripts. That said, if we want to protect ourselves completely, this script could also check against the latest remote tag, and bump the version accordingly.



# Automated tagging
Proof of concept for creating a tag matching master's semver.

#### Usage:
1. After successful merge, `git checkout master && git pull` 
1. Execute `npm run tag` 

#### Script steps:
1. Fetch origin master, to ensure latest `package.json`
1. Extract the highest remote tag number and remote master's semver
1. Compare these 2 and:
    1. if `tag` > `semver`, throw an error (tag should not be ahead of semver) and exit
    1. if `tag` == `semver`, throw a warning (was tag created manually?) and exit
    1. if `tag` < `semver`, create a new tag

#### Notes
While there's a `post-merge` hook, it actually triggers after each `git pull`, so not that useful in this case.   
To automate this process, one would have to configure their CI to listen to a specific Github's webhook and trigger the npm script accordingly.

I suppose we could add `git checkout master && git pull` to the script to make it even easier. Perhaps with 
stashing and under a flag, in case someone did a partial commit?
