---
title: Deep Linking
description: Deep Links into Bridge for better integration into DevOps tools
weight: 21
keywords: [bridge]
---

For integration of the Keptn Bridge into DevOps tools, a list of deep links is provided. 

## Deep links into Keptn Bridge

- `project/:projectName`
  - Opens project view of the project specified by `projectName`.
- `project/:projectName/:serviceName`
  - Opens project view of the project specified by `projectName` and expands the service specified by `serviceName`.
- `project/:projectName/:serviceName/:contextId`
  - Opens project view of `projectName`, expands the service specified by `serviceName`, and selects root event of *keptn context* specified by `contextId`.
- `project/:projectName/:serviceName/:contextId/:eventId`: 
  - Opens project view of `projectName`, expands the service specified by `serviceName`, and selects root event of *keptn context* specified by `contextId`. 
  - Finally, Keptn Bridge scrolls to event with the `eventId`.
- `trace/:shkeptncontext`
  - Loads that root event and redirects to `project/:projectName/:serviceName/:contextId`
- `trace/:shkeptncontext/:stage`
  - Loads that root event and redirects to `project/:projectName/:serviceName/:contextId/:eventId` where eventId is the id of the first event of the specific stage.
- `trace/:shkeptncontext/:eventtype`
  - Loads that root event and redirects to `project/:projectName/:serviceName/:contextId/:eventId` where eventId is the id of the last event with the specific event type.

- `evaluation/:shkeptncontext`
  - Loads the Evaluation Board of the root event with the *keptn context* specified by `contextId` with the evaluation comparison on all stages.
- `evaluation/:shkeptncontext/:stage`
  - Loads the Evaluation Board of the event with the *keptn context* specified by `contextId` with the evaluation comparison on the specified `stage`.
- `evaluation/:shkeptncontext/:eventId`
  - Loads the Evaluation Board of the event with the *keptn context* specified by `contextId` with the evaluation comparison of the evaluation event specified by `eventId`.
  
  {{< popup_image
    link="./assets/bridge_evaluationboard.png"
    caption="Keptn Bridge Evaluation Board">}}