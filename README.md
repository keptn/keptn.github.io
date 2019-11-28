# Contribute to the Keptn Website

This is the repository of the [Keptn](https://keptn.sh) website, which uses the [Hugo static website generator framework](http://gohugo.io). 

Perform the following steps to create a copy of this repository on your local machine:

1. Fork the Keptn repository.  
A copy of this repository is available in your github account.

1. Clone the forked repository in a local directory.
    ```
    git clone https://github.com/UserName/keptn.github.io
    ``` 
	Where UserName is your github username. The keptn.github.io directory is available in the local directory.
	
1. Install [Hugo](http://gohugo.io).  
The themes directory on your local machine (localdirectory/keptn.github.io/themes) is empty because the Hugo serif theme is available at https://github.com/jugglerx/hugo-serif-theme. Perform the next step to install this theme.

1. Install the git submodule in the themes directory.
    ```
    git submodule update --init --recursive --force
    ```
1. Execute the `hugo server -D` command from the root folder:
    ```
    hugo server -D    
    ```
1. Enter the following in a browser to view the website:
    ```
    http://localhost:1313/
	
	# Press Ctrl+C to stop the Hugo server
    ```
	Start contributing! Note that all edits to the files are updated immediately.
