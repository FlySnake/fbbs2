## Purpose

Build server like continuous integration, but for arbitrary branches. Helps to implement [feature branches workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow) in a team.

Feature branches != continuous integration. In case of continuous integration, a development workflow looks like this:

1. Developer implements a feature in some branch (or even in master).
2. Developer merges it into master and starts build/test/deploy on continuous integration.
3. QA tests it manually.
4. Feature goes in production.

In case of feature branches it's a little bit different:

1. Developer implements a feature in some branch, especially created for this feature.
2. Developer starts build/test/deploy on feature branches server and pass the build to QA.
3. QA tests this particular build.
4. This branch gets merged into master, QA tests it once again a little bit after merge.

## Why

The project has been created in [System Technologies](http://www.sys4tec.com/) company in a mobile development team for a large C++/Qt mobile/desktop application. Full build took about 15 minutes on a developers' workstations, also usually 2 builds for 2 platforms were required. Back in that time continuous integration was used. It was good for speed and crodd-platform builds, but inconvenient because of feature branches workflow (you cannot chose arbitrary branch to build). We were unable to find existing solution. The original continious integration was replaced by this project very soon and it works pretty good now.

## Architecture

There are 2 components:

1. Control host. Web UI and business logic.
2. Workers. A glue between you build shell script and control host.

You can have as many workers as you need parallel builds on a different machines. Each worker has its own set of options about platforms, testing environment, etc. Control host gives you an interface to control the workers. When you start the build, control host seeks for the first free worker suitable for your build (platform, tests, etc) by priority and sends this worker a command to start. Control host observes all workers and shows you information about a build status in real-time.

## Features

1. Build an arbitrary branch form a git repository.
2. Parallel builds on different workers.
3. Build queue (when there is no available workers, you build task will be queued).
4. Ability to create different build environments with different set of options (i.e.: release, development, test).
5. Ability to create a different versions for your build (i.e.: different commercial versions from the same source code with different set of features).
6. Build-in mechanism for creating build numbers. Bind to commit in a branch, i.e. will be incremented each time you build a new commit in your branch. Transparent for all platforms. Can be configured.
7. Convert commit sha into a link to repository where you can see online diff (bitbucket, github and any other systems supported if the allows to set a commit in url).
8. Convert numbers or any other symbols (regex is used) into a link to your project management system.
9. Watching for new commits in each branch (using hooks). Whenever there is a new commit in a branch you'll see a small start near its name.
10. User notifications.
11. Visualising tests results.

## Demo

TODO.

## Installation

TODO. Please, contact the author if you are interested in this project.

## Development

Please, contact me.

## License

AGPL
