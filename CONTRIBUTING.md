# Contribute to the Keptn Website

This document provides information about contributing to the [Keptn documentation](https://keptn.sh/docs/), which is part of the [Keptn](https://keptn.sh) website.
This documentation is authored with [markdown](https://www.markdownguide.org/basic-syntax/)
and rendered using the [Hugo static website generator framework](http://gohugo.io).

## Fork and clone the repository

Perform the following steps to create a copy of this repository on your local machine:

1. Fork the Keptn repository:

     - Go to the [Keptn docs repository](https://github.com/keptn/keptn.github.io).
     - Click the **Fork** button at the top of the screen.
     - Choose the user for the fork from the options you are given.

   A copy of this repository is available in your GitHub account.

2. Get the string to use when cloning your fork:

     - Click the green "Code" button on the UI page.
     - Select the protocol to use for this clone (either HTTPS or SSH).
     - A box is displayed that gives the URL for the selected protocol.
Click the icon at the right end of that box to copy that URL.

3. Clone the forked repository from the shell in a local directory with the **git clone** command, pasting in the URl you saved in the previous step:
    ```
    git clone https://github.com/<*UserName*>/keptn.github.io
    or
    git clone git@github.com:<*UserName*>/keptn.github.io.git
    ```
	Where <*UserName*> is your github username. The keptn.github.io directory is now available in the local directory.

## Install Hugo to build the docs locally

1. Install the extended version of [Hugo](http://gohugo.io) in [Version 0.53](https://github.com/gohugoio/hugo/releases/tag/v0.53) (see [netlify.toml](netlify.toml) - `HUGO_VERSION = "0.53"`). 

   :warning: It is important that you install the **extended** version of Hugo. Learn how to install Hugo, depending on your OS, here: [install Hugo](https://gohugo.io/getting-started/installing/).

The themes directory on your local machine (localdirectory/keptn.github.io/themes) is empty because the Hugo serif theme is available at https://github.com/zerostaticthemes/hugo-serif-theme. You need to load the git submodule (see next step) to install this theme.

2. Install the git submodule in the themes directory.
    ```
    git submodule update --init --recursive --force
    ```
3. Execute the `hugo server -D` command from the root folder:
    ```
    hugo server -D
    ```
4. Enter the following in a browser to view the website:
    ```
    http://localhost:1313/

	# Press Ctrl+C to stop the Hugo server
    ```

Start contributing! Note that all edits to the files are updated immediately.

### Push to production

Before you push to production, make sure to run the following command in order to get the correctly built files:

```
hugo
```

## Building markdown files without Hugo

The Hugo generator described above only renders the markdown files under the */content/docs* directory.
If you need to render another markdown file (such as this *CONTRIBUTING.md* file) to check your formatting, you have the following options:

   - If you are using an IDE to author the markdown text, use the markdown preview browser for the IDE.
   - You can push your changes to github and use the Github previewer (*View Page*).
   - Install and use the [grip](https://github.com/joeyespo/grip/blob/master/README.md) previewer.

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
  - An *assets* subdirectory where graphical files for that topic are stored
No *assets* subdirectory is present if the topic has no graphics.


