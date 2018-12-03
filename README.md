# Dependencies
1. [Husky](https://github.com/typicode/husky) — npm package for better and easier handling of git hooks (devDependencies)
1. [semver-tool](https://github.com/fsaintjacques/semver-tool) — bash script for semver processing (preinstalled)



# Automated semver
Proof of concept using `post-commit` hook to update `version` in `package.json`. 

#### Usage:
1. Create a new branch and perform whatever work in it.
1. Ensure `Husky` is available and set up by running `npm i` (only required once)
1. Commit and push your work as usual.
1. Observe the "magic" in your commit history.   
<img src="https://media.giphy.com/media/5sgppAtcWgPhS/giphy-downsized.gif" width="400" alt="clearly not magic" />

#### Script steps:
1. If current branch is master, exit
1. Otherwise, fetch origin master, to ensure latest data
1. Extract semvers from local branch's package.json and the current remote master.
1. If branch is greater than master, assume manual bump (as expected for minor and major releases) and exit.
1. Otherwise, bump up the semver (patch level) using master as a base.
1. Update the file
1. Create a new commit

#### Notes
While I was hoping this could be achieved in `pre-push` hook, it turns out it's triggered after the remote 
refs have been updated but before any objects have been transferred. Creating additional commits at this point is 
possible, but requires cancelling original push and triggering a separate one from the hook, which confuses git and 
results in an error. Although it works, is hardly a great dev experience.



# Automated tagging
Proof of concept creating a tag matching master's semver.

#### Usage:
1. After successful merge, `git checkout master`
1. `git pull` 
1. `npm run tag` 

#### Script steps:
1. Fetch and prune all local tags that don't have matching remote instances
1. Extract the highest tag number and remote master's semver
1. Compare these 2 and:
    1. if `tag` > `semver`, throw a warning (tag should not be ahead of semver)
    1. if `tag` == `semver`, exit
    1. if `tag` < `semver`, create a new tag

#### Notes
While there's a `post-merge` hook, it actually triggers after each `git pull`, so not that useful in this case.   
To automate this process, one would have to configure their CI to listen to a specific Github's webhook and trigger the npm script accordingly.
