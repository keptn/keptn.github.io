---
title: Deep Linking
description: Deep links into Bridge for better integration into DevOps tools
weight: 21
keywords: [0.7.x-bridge]
---

For integration of the Keptn Bridge into DevOps tools, a list of deep links is provided. 

## Links to project and events

- `project/:projectName`
  - Opens project view of the project specified by `projectName`.
- `project/:projectName/:serviceName`
  - Opens project view of the project specified by `projectName` and expands the service specified by `serviceName`.
- `project/:projectName/:serviceName/:contextId`
  - Opens project view of `projectName`, expands the service specified by `serviceName`, and selects root event of *keptn context* specified by `contextId`.
- `project/:projectName/:serviceName/:contextId/:eventId`: 
  - Opens project view of `projectName`, expands the service specified by `serviceName`, and selects root event of *keptn context* specified by `contextId`. 
  - Finally, Keptn Bridge scrolls to the event with the `eventId`.
- `trace/:shkeptncontext`
  - Loads that root event and redirects to `project/:projectName/:serviceName/:contextId`
- `trace/:shkeptncontext/:stage`
  - Loads that root event and redirects to `project/:projectName/:serviceName/:contextId/:eventId` where eventId is the id of the first event of the specific stage.
- `trace/:shkeptncontext/:eventtype`
  - Loads that root event and redirects to `project/:projectName/:serviceName/:contextId/:eventId` where eventId is the id of the last event with the specific event type.

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