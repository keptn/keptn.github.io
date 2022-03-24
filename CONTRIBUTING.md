# Contribute to the Keptn website

This document provides information about contributing to the [Keptn documentation](https://keptn.sh/docs/), which is part of the [Keptn](https://keptn.sh) website.

This documentation is authored with [markdown](https://www.markdownguide.org/basic-syntax/)
and rendered using the [Hugo static website generator framework](http://gohugo.io).

We welcome and encourage contributions of all levels.
You can make modifications using the Github editor;
this works well for small modifications but, if you are making significant changes, you may find it better to fork and clone the repository and make changes using the text editor or IDE of your choice.
You can also run the [Hugo](https://gohugo.io/) based website locally to check the rendered documentation
and then push your changes to the repository as a pull request.

If you need help getting started, feel free to ask for help on the `#help-contributing` or `#keptn-docs` channels on the [Keptn Slack](https://keptn.sh/community/#slack).
We were all new to this once and are happy to help you!

## Guidelines for contributing

* Always fork the repository then clone that fork to your local system rather than clone master directly.
Keptn, like most open source projects, severely restricts who can push changes directly to the *master* branch to protect the integrity of the repository.
* Keep your language clean and crisp.
* Smaller PR's are easier to review and so generally get processed more quickly;
when possible, chunk your work into smallish PR's.
However, we recognize that documentation work sometimes requires larger PRs, such as when writing a whole new section or reorganizing existing files.
* You may want to squash your commits before creating the final PR, to avoid conflicting commits.
This is **not mandatory**; the maintainers will squash your commits during the merge when necessary.
* Be sure that the description of the pull request itself is meaningful and described clearly.
This helps reviewers understand each commit and provides a good history after the PR is merged.
* If your PR is not reviewed in a timely fashion, feel free to post a gentle reminder to the `#keptn-docs` Slack channel.
* Resolve review comments and suggestions promptly.

If you see a problem and are unable to fix it yourself or have an idea for an enhancement, please create an issue on the GitHub repository:

* Provide specific and detailed information about the problem and possible solutions to help others understand the issue.
* When reporting a bug, provide a detailed list of steps to reproduce the bug.
If possible, also attach screenshots that illustrate the bug.
* If you want to do the work on an issue, include that information in your description of the issue.

### Guidelines for working on documentation in development or already released documentation

If you want to work on an issue or enhancement, two questions arise: 
1. Does it relate to a *new feature* that is not yet released? 
1. Does it relate to an *already released* Keptn version?

Currently, the Keptn project follows the approach outlined below. For clarification, an example is used in which the Keptn project recently released `0.13.x` and is currently working on `0.14.x`. These release versions will of course increase when the release train moves on. 

**Documentation for new features**

For the new `0.14.x` release, a folder in [content/docs](https://github.com/keptn/keptn.github.io/tree/master/content/docs) is available, which receives documentation for new features or breaking changes. This folder is *hidden*  and not publically rendered. This is controlled with the `ignoreFiles` flag in [config.toml](https://github.com/keptn/keptn.github.io/blob/master/config.toml). 

> Update the content in folder `0.14.x` when documentation for a new feature is needed. 

**Documentation for already released Keptn versions**

For all previous releases like `0.13.x`, `0.12.x`, and lower, a folder in `https://github.com/keptn/keptn.github.io/tree/master/content/docs` is available. If a fix or enhancement of an already released version is needed, the documentation update needs to go into the corresponding folder **and** into the documentation for the release under development if the change is valid for upcoming releases too.

> Update the content in the corresponding folder of the Keptn release **and** in the current folder that is in development. Consequently, your PR will target at least two folders if the change is relevant for the upcoming releases too.

## Fork and clone the repository

Perform the following steps to create a copy of this repository on your local machine:

1. Fork the Keptn repository:

     - Log into Github (or create a GitHub account and then log into it).
     - Go to the [Keptn docs repository](https://github.com/keptn/keptn.github.io).
     - Click the **Fork** button at the top of the screen.
     - Choose the user for the fork from the options you are given, usually your Github ID.

   A copy of this repository is available in your GitHub account.

2. Get the string to use when cloning your fork:

     - Click the green "Code" button on the UI page.
     - Select the protocol to use for this clone (either HTTPS or SSH).
     - A box is displayed that gives the URL for the selected protocol.
Click the icon at the right end of that box to copy that URL.

3. Clone the forked repository from the shell in a local directory with the **git clone** command, pasting in the URl you saved in the previous step:
    ```
    git clone https://github.com/<UserName>/keptn.github.io
    ```
    or
    ```
    git clone git@github.com:<UserName>/keptn.github.io.git
    ```
    Where <*UserName*> is your GitHub username. The keptn.github.io directory is now available in the local directory.

4. Remember to sync your fork with the master branch regularly.
To do this:

   Go to GitHub and copy the url of the main keptn-github-io repo:
   ```   
   https://github.com/keptn/keptn.github.io.git
   ```
   make sure to be in the root folder of the project and the branch should be master branch and type:
   ```
   git remote add upstream https://github.com/keptn/keptn.github.io.git 
   ```
   Now you have your upstream setup in your local machine, whenever you need to make a new branch for making changes make sure your master branch is in sync with the main repository, to do this, make sure to be in the master branch:

   ```
   git pull upstream master
   git push origin master
   ```

## Install Hugo to build the docs locally

1. Install the extended version of [Hugo](http://gohugo.io) in [Version 0.53](https://github.com/gohugoio/hugo/releases/tag/v0.53) (see [netlify.toml](netlify.toml) - `HUGO_VERSION = "0.53"`).

   :warning: It is important that you install