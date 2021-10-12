---
title: Deep Linking
description: Deep links into Bridge for better integration into DevOps tools
weight: 30
keywords: [0.8.x-bridge]
---

For integration of the Keptn Bridge into DevOps tools, a list of deep links is provided. 

## Links to project and events

- `project/:projectName`
  - Opens environment view of the project specified by `projectName`.
- `project/:projectName/service`
  - Opens service view of the project specified by `projectName`.
- `project/:projectName/service/:serviceName`
  - Opens service view of the project specified by `projectName` and expands the service specified by `serviceName`.
- `project/:projectName/service/:serviceName/context/:shkeptncontext`
  - Opens service view of the project specified by `projectName`, expands the service specified by `serviceName`, and selects sequence of *keptn context* specified by `shkeptncontext`.
- `project/:projectName/service/:serviceName/context/:shkeptncontext/stage/:stage`
  - Opens service view of the project specified by `projectName`, expands the service specified by `serviceName`, selects sequence of *keptn context* specified by `shkeptncontext` and selects stage specified by `stage`.
- `project/:projectName/sequence`
  - Opens sequence view of the project specified by `projectName`.
- `project/:projectName/sequence/:shkeptncontext`
  - Opens sequence view of the project specified by `projectName` and selects sequence of *keptn context* specified by `shkeptncontext`.
- `project/:projectName/sequence/:shkeptncontext/stage/:stage`
  - Opens sequence view of the project specified by `projectName`, selects sequence of *keptn context* specified by `shkeptncontext` and selects stage specified by `stage`.
- `project/:projectName/sequence/:shkeptncontext/event/:eventId`
  - Opens sequence view of the project specified by `projectName` and selects sequence of *keptn context* specified by `shkeptncontext`.
  - Finally, Keptn Bridge scrolls to the event with the `eventId`.
- `trace/:shkeptncontext`
  - Loads that sequence and redirects to `project/:projectName/sequence/:shkeptncontext`.
- `trace/:shkeptncontext/:stage`
  - Loads that sequence and redirects to `project/:projectName/sequence/:shkeptncontext/stage/:stage`.
- `trace/:shkeptncontext/:eventtype`
  - Loads that sequence and redirects to `project/:projectName/sequence/:shkeptncontext/event/:eventId` where eventId is the id of the last event with the specific event type.

## Links to evaluation board

The evaluation board displays the evaluation comparison of one or multiple stages depending on the deep link.

- `evaluation/:shkeptncontext`
  - Loads the evaluation board with the *keptn context* specified by `shkeptncontext` with the evaluation comparison on all stages.
- `evaluation/:shkeptncontext/:stage`
  - Loads the evaluation board with the *keptn context* specified by `shkeptncontext` with the evaluation comparison on the specified `stage`.
- `evaluation/:shkeptncontext/:eventId`
  - Loads the evaluation board with the *keptn context* specified by `shkeptncontext` with the evaluation comparison of the event specified by `eventId`.
  
    {{< popup_image
      link="./assets/bridge_evaluationboard.png"
      caption="Keptn Bridge Evaluation Board"
      width="80%">}}

## Deprecated links

Links which were introduced in `0.7.x` are still compatible with `0.8.x` but they are deprecated.

- `project/:projectName/:serviceName`
  - Redirects to `project/:projectName/service/:serviceName`.
- `project/:projectName/:serviceName/:contextId`
  - Redirects to `project/:projectName/sequence/:shkeptncontext`.
- `project/:projectName/:serviceName/:contextId/:eventId`
  - Redirects to `project/:projectName/sequence/:shkeptncontext/event/:eventId`.
