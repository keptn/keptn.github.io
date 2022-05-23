# Contribute to the Keptn website

This document provides information about contributing to the [Keptn documentation](https://keptn.sh/docs/), which is part of the [Keptn](https://keptn.sh) website.

This documentation is authored with [markdown](https://www.markdownguide.org/basic-syntax/)
and rendered using the [Hugo static website generator framework](http://gohugo.io).

We welcome and encourage contributions of all levels.
You can make modifications using the GitHub editor;
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

## Fork and clone the repository

Perform the following steps to create a copy of this repository on your local machine:

1. Fork the Keptn repository:

     - Log into GitHub (or create a GitHub account and then log into it).
     - Go to the [Keptn docs repository](https://github.com/keptn/keptn.github.io).
     - Click the **Fork** button at the top of the screen.
     - Choose the user for the fork from the options you are given, usually your GitHub ID.

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
    or
    gh repo clone <UserName>/keptn.github.io
    ```
    Where <*UserName*> is your GitHub username. The keptn.github.io directory is now available in the local directory.

> Be sure that [Git](https://github.com/git-guides/install-git) and [Github CLI](https://cli.github.com/) are installed on your system.

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

## Guidelines for working on documentation in development or already released documentation

If you want to work on an issue or enhancement, two questions arise: 
1. Does it relate to a *new feature* that is not yet released? 
1. Does it relate to an *already released* Keptn version?

Currently, the Keptn project follows the approach outlined below. For clarification, an example is used in which the Keptn project recently released `0.13.x` and is currently working on `0.14.x`. These release versions will of course increase when the release train moves on. 

**Documentation for new features**

For each recent release (e.g. `0.14.x`), a folder in [./content/docs](https://github.com/keptn/keptn.github.io/tree/master/content/docs) is available, which receives documentation for new features or breaking changes. This folder is *hidden*  and not publically rendered. This is controlled with the `ignoreFiles` flag in [config.toml](https://github.com/keptn/keptn.github.io/blob/master/config.toml). When writing your documentation enhancements or changes locally - as explained in the section [Install Hugo to build the docs locally](https://github.com/keptn/keptn.github.io/blob/master/CONTRIBUTING.md#install-hugo-to-build-the-docs-locally) - control the rendering by adding/removing the folder from the `ignoreFiles` in `config.toml`. However, make sure to not push the modified `config.toml` when filing your PR. 

> Update the content in folder `0.14.x` when documentation for a new feature is needed. 

**Documentation for already released Keptn versions**

For all previous releases like `0.13.x`, `0.12.x`, and lower, a folder in [./content/docs](https://github.com/keptn/keptn.github.io/tree/master/content/docs) is available. If a fix or enhancement of an already released version is needed, the documentation update needs to go into the corresponding folder **and** into the documentation for the release under development if the change is valid for upcoming releases too.

> Update the content in the corresponding folder of the Keptn release **and** in the current folder that is in development. Consequently, your PR will target at least two folders if the change is relevant for the upcoming releases too.

## Install Hugo to build the docs locally

1. Install the extended version of [Hugo](http://gohugo.io) in [Version 0.53](https://github.com/gohugoio/hugo/releases/tag/v0.53) (see [netlify.toml](netlify.toml) - `HUGO_VERSION = "0.53"`).

   :warning: It is important that you install the **extended** version of Hugo. Learn how to install Hugo, depending on your OS, here: [install Hugo](https://gohugo.io/getting-started/installing/).

The themes directory on your local machine (localdirectory/keptn.github.io/themes) is empty.
Currently the website uses the _Hugo serif theme_ which is available at https://github.com/zerostaticthemes/hugo-serif-theme.
You need to load the git submodule (see next step) to install this theme.

2. Load the git submodule for the Hugo theme in the *themes* directory:
    ```
    git submodule update --init --recursive --force
    ```
3. Execute the following command from the root folder of your clone:
    ```
    hugo server -D
    ```
4. Start contributing!
Leave the Hugo server running in a shell.
Note that Hugo updates the rendered documentation each time you write the file.

5. Enter the following in a browser to view the website:
    ```
    http://localhost:1313/
    ```
6. Use Ctrl+C to stop the local Hugo server when you are done.

## Building markdown files without Hugo

The Hugo generator described above only renders the markdown files under the */content/docs* directory.
If you need to render another markdown file (such as this *CONTRIBUTING.md* file) to check your formatting, you have the following options:

   - If you are using an IDE to author the markdown text, use the markdown preview browser for the IDE.
   - You can push your changes to GitHub and use the GitHub previewer (*View Page*).
   - You can install and use the [grip](https://github.com/joeyespo/grip/blob/master/README.md) previewer to view the rendered content locally.
When *grip* is installed, you can format the specified file locally by running the following in its own shell:
     ```
     grip <file>.md
     ```
     Point your browser at `localhost:6419` to view the formatted file.
     The document updates automatically each time you write your changes to disk.

## Source file structure

The source files for the [Keptn Documentation](https://keptn.sh/docs/) are stored under the *content/docs* directory in the repository.
The build strategy is to build everything except for the files/folders that are listed in the `ignoreFiles` array in the [config.toml](https://github.com/keptn/keptn.github.io/blob/master/config.toml) file.

The order in which the files are displayed is determined by the value of the `weight` field in the metadata section of *_index.md* and *index.md* files located throughout the directory tree.

The metadata section of these files contains at least four fields.
As an example, the metadata section for the *Concepts* section of the documentation is:

```
title: Concepts
description: Learn about the core concepts, use-cases, and architecture of Keptn.
weight: 2
icon: concepts
```

The meaning of these fields is:

* **title** -- title displayed for the section or file
* **description** -- subtext displayed for the section or subsection
* **weight** -- order in which section or subsection is desplayed relative to other sections and subsections at the same level.
In this case, the weight of 2 means that this section is displayed after *Quick Start* (which has a weight of 1) and before *Roadmap* (which has a weight of 3).
* **icon** -- determines the icon displayed next to titles in content listings.  Values used in the Keptn docs include `concepts`, `docs`, `setup`, `tasks`, `setup`, and `reference`.
You can explore the various options used by comparing the doc output with the values used for this field.

Some other fields are sometimes used in the metadata.

### Top level structure

The current tools do not support versioning.
To work around this limitation, the docs are arranged with some general topics that generally apply to all releases and then subsections for each release that is currently supported.

The system for assigning weights for the docs landing page is:

* General introductory material uses weight values under 100.
* Sections for individual releases use weight values of 9**.
* Sections for general but advanced info use weight value of 1***.

### Subdirectory structure

Each subdirectory contains topical subdirectories for each chapter in that section.
Each topical subdirectory contains:

  - An *index.md* file that has the metadata discussed above plus the text for the section
  - An *assets* subdirectory where graphical files for that topic are stored.
No *assets* subdirectory is present if the topic has no graphics.

## Submitting new content through a pull request

If you have forked and cloned the repository,
you can modify the documentation or add new material
by editing the markdown file(s) in the local clone of your fork
and then submitting a _pull request (PR)_.

Note that you can also modify the source using the GitHub editor.
This is very useful when you want to fix a typo or make a small editorial change but, if you are doing significant writing, it is generally better to work on files in your local clone.

The following sequence of steps is a reasonable workflow for creating new content on your local clone and pushing it to GitHub to be reviewed and merged.

1. Execute the following command from the root folder and leave it running in a shell:
    ```
    hugo server -D
    ```
2. Create a local branch for your changes.  Be sure to base your new branch on the contents of the `master` branch unless you intend to create a derivative PR:
   ```
   git checkout master
   git pull
   git checkout -b <your-new-branch>
   ```
3. Execute the following and check the output to ensure that your branch is set up correctly:
   ```
   git status
   ```

3. Do the writing you want to do in your local branch, checking the formatted version at `localhost:1313`.

4. When you have completed the writing you want to do, close all files in your branch and run `git status` to confirm that it correctly reflects the files you have modified, added, and deleted.

4. Add and commit your changes.  Here, we commit all modified files but you can specify individual files to the `git add` command.
The `git commit -s` command commits the files and signs that you are contributing this intellectual property to the Keptn project.
   ```
   git add .
   git commit -s
   ```

   Use vi commands to add a description of the PR (should be 80 characters or less) to the commit. This will be displayed as the title of the PR in listings.
You can add multiple lines explaining the PR here but, in general, it is better to only supply the PR title here; you can add more information and edit the PR title when you create the PR on the GitHub UI page.

5. Push your branch to github:
   - If you cloned your fork to use SSH, the command is:
     ```
     git push --set-upstream origin <branch-name>
     ```

     Note that you can just issue the `git push` command.
Git responds with an error message that gives you the full command line to use; you can copy this command and paste it into your shell to push the content.
   - If you cloned your fork to use HTTP, the command is:
     ```
     git push <need options/arguments>
     ```

6. Create the PR by going to the [keptn.github.io](https://github.com/keptn/keptn.github.io) GitHub repository.
   - You should see a yellow shaded area that says something like:
     ```
     <GitID>:<branch> had recent pushes less than a minute ago
     ```

   - Click on the button in that shaded area marked:
     ```
     Compare & pull request
     ```
   - Check that the title of the PR is correct; click the "Edit" button to modify it.
Add "WIP" (Work in Progress) or "Draft" to the title if the PR is not yet ready for general review.
   - Add a full description of the work in the PR, including any notes for reviewers, a reference to the relevant GitHub issue (if any), and tags for specific people (if any) who may be interested in this PR.
   - Carefully review the changes GitHub displays for this PR to ensure that they are what you want.
   - Click the green "Create pull request" button to create the PR.
You may want to record the PR number somewhere for future reference although you can always find the PR in the GitHub lists of open and closed PRs.
   - GitHub automatically populates the "Reviewers" block.
   - If this PR is not ready for review, click the "Still in progress? Convert to draft" string under the list of reviewers.
People can still review the content but can not merge the PR until you remove the "Draft" status.
   - The block of the PR that reports on checks will include the following item:
     ```
     This pull request is still a work in progress
     Draft pull requests cannot be merged.
     ```
   - When the PR is ready to be reviewed, approved, and merged, click the "Ready to review" button to remove the "Draft" status. Then, if you added "WIP" or "Draft" to the PR title, remove it now.

7. Your PR should be reviewed within a few days.  Watch for any comments that may be added by reviewers and implement or respond to the recommended changes as soon as possible.

   * If a reviewer makes a GitHub suggestion and you agree with the change, just click "Accept this change" to create a commit for that modification.  You can also group several suggestions into a single commit using the GitHub tools.
   * You can make other changes using the GitHub editor or you can work in your local branch to make modifications.

      * If changes have been made using the GitHub editor, you will need to do a `git pull` request to pull those commits back to your local branch before you push the new changes.
      * After modifying the local source, issue the `git add .`, `git commit`, and `git push` commands to push your changes to github.

8. When your PR has the appropriate approvals, it will be merged and the revised content should be published on the web site within a few minutes.

9. When your PR has been approved and merged, you can delete your local branch with the following command:
   ```
   git branch -d <branch-name>
   ```

### Developer Certification of Origin (DCO)

Licensing is very important to open source projects. It helps ensure the software continues to be available under the terms that the author desired.

Keptn uses [Apache License 2.0](https://github.com/keptn/keptn.github.io/blob/master/LICENSE) to strike a balance between open contributions and allowing you to use the software however you would like to.

The license tells you what rights you have that are provided by the copyright holder. It is important that the contributor fully understands what rights they are licensing and agrees to them. Sometimes the copyright holder isn't the contributor, such as when the contributor is doing work on behalf of a company.

To make a good faith effort to ensure these criteria are met, Keptn requires the Developer Certificate of Origin (DCO) process to be followed.

The DCO is an attestation attached to every contribution made by every developer. In the commit message of the contribution, the developer simply adds a Signed-off-by statement and thereby agrees to the DCO, which you can find below or at <http://developercertificate.org/>.

```
Developer Certificate of Origin
Version 1.1

Copyright (C) 2004, 2006 The Linux Foundation and its contributors.

Everyone is permitted to copy and distribute verbatim copies of this
license document, but changing it is not allowed.


Developer's Certificate of Origin 1.1

By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I
    have the right to submit it under the open source license
    indicated in the file; or

(b) The contribution is based upon previous work that, to the best
    of my knowledge, is covered under an appropriate open source
    license and I have the right under that license to submit that
    work with modifications, whether created in whole or in part
    by me, under the same open source license (unless I am
    permitted to submit under a different license), as indicated
    in the file; or

(c) The contribution was provided directly to me by some other
    person who certified (a), (b) or (c) and I have not modified
    it.

(d) I understand and agree that this project and the contribution
    are public and that a record of the contribution (including all
    personal information I submit with it, including my sign-off) is
    maintained indefinitely and may be redistributed consistent with
    this project or the open source license(s) involved.
```

#### DCO Sign-Off Methods

The DCO requires a sign-off message in the following format to appear on each commit in the pull request:

```
Signed-off-by: Humpty Dumpty <humpty.dumpty@example.com>
```

The DCO text can either be manually added to your commit body, or you can add either **-s** or **--signoff** to your usual git commit commands. If you are using the GitHub UI to make a change you can add the sign-off message directly to the commit message when creating the pull request. If you forget to add the sign-off you can also amend a previous commit with the sign-off by running **git commit --amend -s**. If you've pushed your changes to GitHub already you'll need to force push your branch after this with **git push -f**.

**ATTRIBUTION**:

- https://probot.github.io/apps/dco/
- https://github.com/opensearch-project/common-utils/blob/main/CONTRIBUTING.md
- https://code.asam.net/simulation/wiki/-/wikis/docs/project_guidelines/ASAM-DCO?version_id=c510bffb1195dc04deb9db9451112669073f0ba5
- https://thesofproject.github.io/latest/contribute/contribute_guidelines.html