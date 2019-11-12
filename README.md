# Overview

This repository contains the content for the https://keptn.sh website. The site is developed using the [Hugo static website generator framework](http://gohugo.io).

# Local content development

1. Clone the repository:
    ```
    git clone git@github.com:keptn/keptn.github.io.git
    ``` 
1. Install [Hugo](http://gohugo.io)
1. Install the git submodule
    ```
    git submodule update --init --recursive --force
    ```
1. Execute the `hugo server -D` command from the root folder:
    ```
    # start the hugo web server
    hugo server -D

    # Press Ctrl+C to stop
    ```
1. View the content in the browser. Note that edits to files are updated real-time.
    ```
    http://localhost:1313/
    ```
