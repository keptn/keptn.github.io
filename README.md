# Keptn.sh

This is the repository for the [keptn.sh website](https://keptn.sh).

## Development

### Prerequisites

#### Git
Git is used as a version control system which is used to develop new features in branches.

You can install git following the official [git install instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

You can use [homebrew](https://brew.sh/) on MacOS and run the following command in the terminal. 

```sh
brew install git
```

#### Hugo
This site is built using the open-source static site generator Hugo. You can install Hugo by following [these instructions](https://gohugo.io/getting-started/installing/).

You can make sure that Hugo is installed running the following command in the terminal. 

```sh
hugo version
```

### How to run website on local server

To get started with development, navigate to the source directory of your local Keptn website repository within your terminal. 
Run the following command:

```sh
hugo server -D
```

Navigate to the local site at [http://localhost:1313/](http://localhost:1313/)

Hugo comes with [LiveReload](https://github.com/livereload/livereload-js) built in so any changes will automatically reflect inside your browser.

### Theme

This website is built on the [HugoSerif](https://themes.gohugo.io/hugo-serif-theme/) theme which is included as a submodule inside the /themes folder. Files residing in this folder should under no circumstances be edited. To override any theme specific rules first copy asset into an equivalent folder inside the root directory and edit the file there.

## Publishing

### Compiling

Before commiting changes to this repository, run the folling command to compile the website assets:

```sh
hugo
```

### Deployment

Commit all files (including generated files) to the git repository. Commits to the master branch will trigger automatic deployment via [Netlify](https://www.netlify.com/)

