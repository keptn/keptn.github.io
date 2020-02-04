# Contribute to the Keptn Website

This is the repository of the [Keptn](https://keptn.sh) website, which uses the [Hugo static website generator framework](http://gohugo.io). 

## Run locally

Perform the following steps to create a copy of this repository on your local machine:

1. Fork the Keptn repository.
A copy of this repository is available in your github account.

2. Clone the forked repository in a local directory.
    ```
    git clone https://github.com/UserName/keptn.github.io
    ``` 
	Where UserName is your github username. The keptn.github.io directory is available in the local directory.
	
3. Install the **extended** version of [Hugo](http://gohugo.io) in [Version 0.51](https://github.com/gohugoio/hugo/releases/tag/v0.51) (see [themes/hugo-serif-theme/netlify.toml](themes/hugo-serif-theme/netlify.toml) - `HUGO_VERSION = "0.51"`).  
The themes directory on your local machine (localdirectory/keptn.github.io/themes) is empty because the Hugo serif theme is available at https://github.com/jugglerx/hugo-serif-theme. You need to load the git submodule (see next step) to install this theme.

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
