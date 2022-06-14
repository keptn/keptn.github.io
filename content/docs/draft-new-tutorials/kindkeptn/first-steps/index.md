---
title: First steps after installation
description: Run "Hello, World!" on TheKindKeptn
weight: 20
---

Head to the [Keptn Bridge](http://localhost/bridge), which is the UI from which you can observe and manage what Keptn executes.

You should understand a bit of Keptn terminology:
* Each Keptn project contains one or more stages, each of which corresponds to an environment, such as development or production.
+ Each stage contains one or more sequences, each of which corresponds to a major objective, such as delivery of an artifact or a rollback action.
* A sequence is a list of `tasks` to be executed sequentially.
  Most `tasks` describe a piece of work accomplised by the external tools you have configured,
  such as `evaluation` or `approval`.
  
In this case, we have one project, `helloworld`, which has one stage, `demo`,
that contains one `sequence`, which prints out "Hello, world!".

* Click `demo` from the Bridge dashboard to go to that stage.
* Click `hello` to [go to the sequence view](http://localhost/bridge/project/helloworld/sequence) for the project.

You can see that:
* The sequence has completed successfully
* The log output is `Hello, world!`

![hello world sequence](assets/hello-world-sequence.jpg)

The installation created a Git upstream repo that is separate from the repo where your source code is stored.
This is used as the "backing storage" for keptn. Every change is recorded in this Git upstream.
To view the contents of this repository from the Bridge, click on "??"

The installer created a keptn project which is defined in the `shipyard.yaml` file stored in the `main` branch of the upstream. A shipyard file defines your environment ([more details here](https://keptn.sh/docs/{{ .site.keptn_docs_version }}/manage/shipyard/)). The shipyard also defines the available sequences and tasks that will execute. Right now there is only one stage: `demo` with one sequence: `hello` and that sequence has only one task: `hello-world`.

Keptn creates a separate branch per stage. All configurations and files related to that stage are found under that branch. Keptn creates a folder for each service (`demoservice`).

> Note: Stages cannot currently be added, removed or renamed after project creation. This is a [known limitation](https://github.com/keptn/enhancement-proposals/pull/70)

----

## Executing Jobs

How exactly did the `Hello, world!` get there?

Along with Keptn core microservices, one additional service was installed: the [job executor service](https://github.com/keptn-contrib/job-executor-service). This service is extremely flexible and allows Keptn to spin up any container or script (eg. Python, bash or powershell).

The job-executor is configured to listen for the `sh.keptn.event.hello-world.triggered` event. In other words, when Keptn requests that the task is executed, the job executor actions the task in response to that cloudevent.

### Sounds good. Show me

Switch to the `demo` branch and go to `demoservice/job/jobconfig.yaml`. The files show that the Job Executor Service (JES) listens for `sh.keptn.event.hello-world.triggered` and, in response, spins up an `alpine` container and executes `echo "Hello, world!"`.

> Play around with this file: Echo different words or run an entirely different container in response to the event.

## Nice, but let's do something useful

Excellent, you've seen how Keptn allows bringing your own tools and decouples logic from tooling and are keen to progress.

[Head here](full-tour.md) next to build an artifact delivery platform using Helm with prometheus SLO-driven quality evaluations as standard. [Take me there](full-tour.md)...

