---
title: Quick Start
description: Learn how to get Keptn running in five minutes. We'll run Keptn on a local k3d cluster.
icon: concepts
layout: quickstart
weight: 1
hidechildren: true # this flag hides all sub pages in the sidebar-multicard.html
---


## Prerequisites
- [Docker](https://docker.com/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [helm](https://helm.sh/) when running the demos in step 5

## Install Keptn

1. Create local k3d cluster

    First, install [k3d](https://k3d.io) if not already present on your machine:
    ```
    curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | TAG=v4.4.4 bash
    ```

    Now, let's start a cluster for Keptn!
    ```
    k3d cluster create mykeptn -p "8082:80@agent[0]" --k3s-server-arg '--no-deploy=traefik' --agents 1
    ```

1. Get Keptn CLI

    ```
    curl -sL https://get.keptn.sh | bash
    ```

1. Install Keptn
  
    ```
    keptn install --use-case=continuous-delivery 
    ```

    If you want to install Keptn yourself without following the quickstart guide, have a look at the [install options](../).

1. Install and configure Istio for Ingress + continuous delivery use-case
    ```
    curl -SL https://raw.githubusercontent.com/keptn/keptn.github.io/...TBD.../content/docs/quickstart/exposeKeptnConfigureIstio.sh | bash 
    ```
    

1. (Optional but recommended) Create a demo project with multi-stage pipeline + SLO-based quality gates
    ```
    curl -SL https://raw.githubusercontent.com/keptn/keptn.github.io/...TBD.../content/docs/quickstart/get-demo.sh | bash
    ```

1. Explore Keptn! Please have a look at our [tutorials](https://tutorials.keptn.sh) and [documentation](../) to learn how you can use Keptn.


## Explore tutorials to learn more about the Keptn use cases

With Keptn installed, have a look at the different [tutorials](https://tutorials.keptn.sh/) to learn hands-on about the Keptn use cases: 

<table class="highlight-table">
  <tr>
    <td colspan="6">
      <a href="https://tutorials.keptn.sh/?cat=full-tour">
        <strong>A full tour through Keptn: Continuous Delivery & Automated Operations</strong><br><br>
        Learn how to setup Keptn for a sample cloud native app where Keptn deploys, tests, validates, promotes and auto-remediates
      </a>
    </td>
  </tr>
  <tr>
    <td colspan="3" width="50%">
      <a href="https://tutorials.keptn.sh/?cat=quality-gates">
        <strong>Continuous Delivery with Deployment Validation</strong><br><br>
        Keptn deploys, tests, validates and promotes your artifacts across a multi-stage delivery process
      </a>
    </td>
    <td colspan="3">
      <a href="https://tutorials.keptn.sh/?cat=automated-operations">
        <strong>Automated Operations</strong><br><br>
        Keptn automates problem remediation in production through self-healing and runbook automation
      </a>
    </td>
  </tr>
  <tr>
    <td colspan="2" width="33%">
        <strong>Performance as a Self-Service</strong><br><br>
        Keptn deploys, tests and provides automated performance feedback of your artifacts
    </td>
    <td colspan="2" width="33%">
        <strong>Performance Testing as a Self-Service</strong><br><br>
        Let Keptn execute performance tests against your deployed software and provide automatic SLI/SLO based feedback
    </td>
    <td colspan="2">
        <strong>Deployment Validation (aka Quality Gates)</strong><br><br>
        Integrate Keptn into your existing CI/CD by automatically validating your monitored environment based on SLIs/SLOs
    </td>
  </tr>
</table>

## Learn how Keptn works and how it can be adapted to your use cases

Review the documentation for a full reference on all Keptn capabilities and components and how they can be combined/extended to your needs:

- [Operate Keptn](../0.8.x/operate)
- [Manage Keptn](../0.8.x/manage)
- [Continuous Delivery](../0.8.x/continuous_delivery)
- [Quality Gates](../0.8.x/quality_gates)
- [Automated Operations](../0.8.x/automated_operations)
- [Custom Integrations](../0.8.x/integrations)

## Do you need help?

Join [our slack channel](https://slack.keptn.sh) for any questions that may arise.
