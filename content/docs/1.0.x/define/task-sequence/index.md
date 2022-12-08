---
title: Tasks and sequences
description: Learn about tasks and sequences that define what your project does
weight: 20
keywords: [1.0.x-define]
aliases:
---

In [Start a project](../../manage/project),
you defined a [shipyard.yaml](../../reference/files/shipyard) file
and used that to create your project.
You can create a project with a *shipyard* that only has stages
but it does not do anything until you populate `sequences` and `tasks` in those stages.

* A `sequence` is an ordered list of tasks that are triggered sequentially.
  By default, a sequence is a standalone section that runs and finishes,
  although you can define a certain sequence to run only after another sequence completes,
  or you can specify that it runs only if another sequence runs successfully
  or if the other sequence fails;
  this essentially forms a chain of sequences.
* A single `task` is the smallest executable unit.
Remember that, in Keptn, a `task` defines **what** to do (run a performance test
or try to repair a problem on your site)
but does not define **how** to do that (such as which tool to use).

Sequences can be triggered in a variety of ways; see [Triggers](../triggers) for details and examples
or watch the [Trigger a Keptn Sequence](https://www.youtube.com/watch?v=S0eumPKuAJY) video
for a demonstration of triggering a sequence using the [Keptn Bridge](../../bridge).

The [Lifecycle of a Keptn task](https://www.youtube.com/watch?v=Qtz0vi6ms3A) video
discusses how Keptn executes tasks by issuing events.

For more details about tasks and sequences,
see the [shipyard](../../reference/files/shipyard) reference file

Other pages in this section show specific examples of how to define
sequences and tasks for various purposes.

