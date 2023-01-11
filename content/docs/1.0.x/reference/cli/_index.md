---
title: Keptn CLI
description: Usage information and full syntax of CLI commands.
weight: 30
icon: help
---

This section provides detailed usage information for the Keptn CLI commands.
The Keptn CLI includes commands to perform various tasks
to manage the Keptn installaton and the projects that are run.
It is packaged separately from the Keptn product itself.
It is possible to run current versions of Keptn without the Keptn CLI;
most basic functionality can instead be performed
using the [Keptn bridge](../../bridge).
However, it is recommended that the CLI be installed for production environments
because some functionality is available only through the CLI.

See [Install Keptn CLI](../../install/cli-install) for full installation instructions.
After you install both the Keptn CLI and Keptn itself,
you must authenticate the CLI and the Bridge
as discussed in
[Authenticate Keptn CLI and Bridge](../../install/authenticate-cli-bridge).

## Start using Keptn CLI

These reference pages describe all the commands provided by the Keptn CLI.
To list all available commands just execute:
    
```
keptn --help
```

Each Keptn CLI command also supports the help flag (`--help`),
which describes details of the respective command,
including usage tips for the command and description of flags and arguments.

The rest of this introduction provides some usage notes
to make the Keptn CLI more convenient.

## Use Keptn CLI with multiple contexts

After authenticating the Keptn CLI with multiple Kubernetes clusters, we can directly run Keptn CLI commands in the current context. 

* As soon as you switch the Kube context (e.g., by executing: `kubectl config use-context my-cluster-name`), the Keptn CLI will detect the change of the Kube context and ask you to run the command in the changed context or not. 

* If the Keptn CLI is authenticated for that particular context, the command will run successfully; else it will end up throwing the error: `This command requires to be authenticated. See "keptn auth" for details"`

* In case of multi-installation of Keptn in the same cluster, we need to pass the flag `--namespace` or `-n` to tell the Keptn CLI to use the credentials for that particular Keptn installation, else it will take the default namespace which is: `keptn`

## Use Keptn CLI with KEPTNCONFIG

The `KEPTNCONFIG` environment variable holds a config file that contains the credentials (i.e. API_TOKEN and ENDPOINT) for the Keptn installation.

* The `KEPTNCONFIG` file format:

  ```
  contexts:     
  - api_token: abcdxxxxxxxx1234
    endpoint: https://localhost:8080/api
    name: keptn-test                  # context name                    
    namespace: keptn-test             # namespace name, the default is `keptn` if not set
  - api_token: abcdxxxxxxxx1234
    endpoint: https://91.xxx.xxx.xxx.nip.io/api
    name: keptn-demo        
  ```

* If `KEPTNCONFIG` environment variable is defined, the Keptn CLI reads the credentials from it. 

* If the credentials are not found in the config file, it will fall back to the credential manager.

## Enabling shell autocompletion of Keptn CLI

Keptn CLI provides autocompletion support for Bash and Zsh, which can save you a lot of typing.

Below are the procedures to set up autocompletion for Bash and Zsh. Please expand the corresponding section matching your configuration.

<details><summary>Autocompletion for Bash (Linux)</summary>

The Keptn CLI completion script for Bash can be generated with the command `keptn completion bash`. Sourcing the completion script in your shell enables Keptn CLI autocompletion.

However, the completion script depends on bash-completion, which means that you have to install this software first (you can test if you have bash-completion already installed by running `type _init_completion`).

### Install bash-completion for Linux

bash-completion is provided by many package managers (see [here](https://github.com/scop/bash-completion#installation)). You can install it with `apt-get install bash-completion` or `yum install bash-completion`, etc.

The above commands create /usr/share/bash-completion/bash_completion, which is the main script of bash-completion. Depending on your package manager, you have to manually source this file in your ~/.bashrc file.

To find out, reload your shell and run `type _init_completion`. If the command succeeds, you're already set, otherwise add the following to your ~/.bashrc file:

```bash
source /usr/share/bash-completion/bash_completion
```

Reload your shell and verify that bash-completion is correctly installed by typing `type _init_completion`.

### Enable Keptn CLI autocompletion for linux (bash)

You now need to ensure that the Keptn CLI completion script gets sourced in all your shell sessions. There are two ways in which you can do this:

- source the completion script in your ~/.bashrc file:

```bash
echo 'source <(keptn completion bash)' >>~/.bashrc
```

- Add the completion script to the /etc/bash_completion.d directory:

```bash
keptn completion bash >/etc/bash_completion.d/keptn
```

If you have an alias for Keptn CLI, you can extend shell completion to work with that alias:

```bash
echo 'alias kc=keptn' >>~/.bashrc
echo 'complete -F __start_keptn kc' >>~/.bashrc
```

After reloading your shell, Keptn CLI autocompletion will be enabled successfully.
</details>

<details><summary>Autocompletion for Bash (macOS)</summary>

The Keptn CLI completion script for Bash can be generated with `keptn completion bash`. Sourcing this script in your shell enables Keptn CLI autocompletion.

However, the Keptn CLI autocompletion script depends on bash-completion which you thus have to previously install.

> Warning: There are two versions of bash-completion, v1 and v2. V1 is for Bash 3.2 (which is the default on macOS), and v2 is for Bash 4.1+. The Keptn CLI autocompletion script doesn't work correctly with bash-completion v1 and Bash 3.2. It requires bash-completion v2 and Bash 4.1+. Thus, to be able to correctly use the Keptn CLI autocompletion on macOS, you have to install and use Bash 4.1+ (instructions). The following instructions assume that you use Bash 4.1+ (that is, any Bash version of 4.1 or newer).

### Install bash-completion for macOS

**Note**: As mentioned, these instructions assume you use Bash 4.1+, which means you will install bash-completion v2 (in contrast to Bash 3.2 and bash-completion v1, in which case Keptn CLI completion won't work).

You can test if you have bash-completion v2 already installed with `type _init_completion`. If not, you can install it with Homebrew:

```bash
brew install bash-completion@2
```

As stated in the output of this command, add the following to your ~/.bash_profile file:

```bash
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
```

Reload your shell and verify that bash-completion v2 is correctly installed with `type _init_completion`.

### Enable autocompletion for macOS (bash)

You now have to ensure that the Keptn CLI completion script gets sourced in all your shell sessions. There are multiple ways to achieve this:

- Source the completion script in your ~/.bash_profile file:

```bash
echo 'source <(keptn completion bash)' >>~/.bash_profile
```

- Add the completion script to the /usr/local/etc/bash_completion.d directory:

```bash
keptn completion bash >/usr/local/etc/bash_completion.d/keptn
```

- If you have an alias for Keptn CLI, you can extend shell completion to work with that alias:

```bash
echo 'alias kc=keptn' >>~/.bash_profile
echo 'complete -F keptn kc' >>~/.bash_profile
```

After reloading your shell, Keptn CLI autocompletion will be enabled successfully.

</details>

<details><summary>Autocompletion for Zsh</summary>

The Keptn CLI completion script for Zsh can be generated with the command `keptn completion zsh`. 
Sourcing the completion script in your shell enables Keptn CLI autocompletion.

To do so in all your shell sessions, add the following to your ~/.zshrc file:

```bash
source <(keptn CLI completion zsh)
```

Set the keptn completion code for zsh to autoload on startup by executing the following: 

```bash
keptn completion zsh > "${fpath[1]}/_keptn
```

If you have an alias for Keptn CLI, you can extend shell completion to work with it as follows:

```bash
echo 'alias kc=keptn' >>~/.zshrc
echo 'complete -F __start_keptn kc' >>~/.zshrc
```

After reloading your shell, Keptn CLI autocompletion will be enabled successfully.

If you encounter an error similar to `complete:13: command not found: compdef`, then add the following to the beginning of your `~/.zshrc` file:

```bash
autoload -Uz compinit
compinit
```

</details>

## Using an HTTP Proxy

To make the CLI access Keptn via an HTTP proxy, you can make use of the environment variables `HTTP_PROXY` and `HTTPS_PROXY`. If these are set, all requests sent by the CLI will go through the specified URL.
The following examples illustrate how these variables can be set on the platforms supported by the CLI:

### Linux or macOS

```bash
$ export HTTP_PROXY=http://10.0.0.1:8888
$ export HTTP_PROXY=http://my-proxy.example.com:8888
$ export HTTPS_PROXY=http://10.0.0.1:8888
$ export HTTPS_PROXY=http://my-proxy.example.com:8888
$ export HTTP_PROXY=http://username:password@my-proxy.example.com:8888 # with basic HTTP authentication
$ export HTTPS_PROXY=http://username:password@my-proxy.example.com:8888 # with basic HTTP authentication
```

### Windows

```console
C:\> setx HTTP_PROXY=http://10.0.0.1:8888
C:\> setx HTTP_PROXY=http://my-proxy.example.com:8888
C:\> setx HTTPS_PROXY=http://10.0.0.1:8888
C:\> setx HTTPS_PROXY=http://my-proxy.example.com:8888
C:\> setx HTTP_PROXY=http://username:password@my-proxy.example.com:8888 # with basic HTTP authentication
C:\> setx HTTPS_PROXY=http://username:password@my-proxy.example.com:8888 # with basic HTTP authentication
```
