# Contribute to the Keptn Website

This is the repository of the [Keptn](https://keptn.sh) website, which uses the [Hugo static website generator framework](http://gohugo.io).
Keptn is a event-driven control-plane for application delivery and automated operations.

## Run locally

Perform the following steps to create a copy of this repository on your local machine:

1. Fork the Keptn repository.
A copy of this repository is available in your GitHub account.

2. Clone the forked repository in a local directory.
    ```
    git clone https://github.com/UserName/keptn.github.io
    ```
	Where UserName is your github username. The keptn.github.io directory is available in the local directory.

3. Install the extended version of [Hugo](http://gohugo.io) in [Version 0.53](https://github.com/gohugoio/hugo/releases/tag/v0.53) (see [netlify.toml](netlify.toml) - `HUGO_VERSION = "0.53"`). 

:warning: It's important that you install the **extended** version of Hugo. Learn how to install Hugo, depending on your OS, here: [install Hugo](https://gohugo.io/getting-started/installing/).

The themes directory on your local machine (localdirectory/keptn.github.io/themes) is empty because the Hugo serif theme is available at https://github.com/zerostaticthemes/hugo-serif-theme. You need to load the git submodule (see next step) to install this theme.

4. Install the git submodule in the themes directory.
    ```
    git submodule update --init --recursive --force
    ```
5. Execute the `hugo server -D` command from the root folder:
    ```
    hugo server -D
    ```
    
6. Enter the following in a browser to view the website:
    ```
    http://localhost:1313/

	# Press Ctrl+C to stop the Hugo server
    ```

Start contributing! Note that all edits to the files are updated immediately.

## Push to production

Before you push to production, make sure to run the following command in order to get the correctly built files:

```
hugo
```

## While contributing, make sure you use a separate branch than the Main branch
1.If you think you can make some patch to fix the issue, fork the repo, and then make a pull request.
2.It's always a good practice to squash your commits before creating a final pull request, avoid conflicting commits.
3.If you don't think you can contribute back to the patch/bug, open a new issue.
4.While submitting the issue try to be as detailed(but also specific) as possible to allow others to understand the bug.
5.Ensure the commits you do include in your PR are clearly described. This makes understanding what each commit is doing easier during review and once they are merged into the  	project.
6.Once you have found the bug, provide the steps to reach the bug, if possible attach the screenshots of the same
7.Keep your language clean and crisp.
8.If your issue goes unread please feel free to add a gentle reminder.

Familiarize with the community [Guidelines](https://github.com/keptn/community)
