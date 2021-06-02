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

1. Create local k3d cluster. Therefore, you need to install [k3d](https://k3d.io) if not already present on your machine. You can skip this if k3d is already available on your machine.
    ```
    curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | TAG=v4.4.4 bash
    ```

    Now, let's **start a cluster for Keptn**!
    ```
    k3d cluster create mykeptn -p "8082:80@agent[0]" --k3s-server-arg '--no-deploy=traefik' --agents 1
    ```

1. **Download and install the [Keptn CLI](../0.8.x/reference/cli)**

    ```
    curl -sL https://get.keptn.sh | bash
    ```

1. **Install Keptn** control-plane and execution-plane for continuous delivery use case
  
    ```
    keptn install --use-case=continuous-delivery 
    ```

    Keptn comes with different installation options, please have a look at the [installation documentation](../0.8.x/operate) for more details on cluster requirements, resource consumption, supported Kubernetes versions, and more.

    <details><summary>Installation logs</summary>
    <p>The installation logs will print the following output:
    <pre>
    Installing Keptn ...
    Helm Chart used for Keptn installation: https://storage.googleapis.com/keptn-installer/keptn-0.8.3.tgz
    Start upgrading Helm Chart keptn in namespace keptn
    Finished upgrading Helm Chart keptn in namespace keptn
    Keptn control plane has been successfully set up on your cluster.
    Installing execution plane services for continuous-delivery use case.
    Start upgrading Helm Chart helm-service in namespace keptn
    Finished upgrading Helm Chart helm-service in namespace keptn
    Start upgrading Helm Chart jmeter-service in namespace keptn
    Finished upgrading Helm Chart jmeter-service in namespace keptn
    &nbsp;---------------------------------------------------
    &nbsp;* To quickly access Keptn, you can use a port-forward and then authenticate your Keptn CLI:
    &nbsp;- kubectl -n keptn port-forward service/api-gateway-nginx 8080:80
    &nbsp;- keptn auth --endpoint=http://localhost:8080/api --api-token=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
    &nbsp;* Alternatively, follow the instructions provided at: https://keptn.sh/docs/0.8.x/operate/install/#authenticate-keptn-cli
    &nbsp;* To expose Keptn on a public endpoint, please continue with the installation guidelines provided at:
    &nbsp;- https://keptn.sh/docs/0.8.x/operate/install#install-keptn
    </pre>
    **There is no need to follow the instructions from the installation log - the quickstart guide will cover this!**
    </p>
    </details>

1. **Install and configure Istio** for Ingress + continuous delivery use-case
    ```
    curl -SL https://raw.githubusercontent.com/keptn/keptn.github.io/...TBD.../content/docs/quickstart/exposeKeptnConfigureIstio.sh | bash 
    ```
    

1. (Optional but recommended) **Create a demo project** with multi-stage pipeline + SLO-based quality gates
    ```
    curl -SL https://raw.githubusercontent.com/keptn/keptn.github.io/...TBD.../content/docs/quickstart/get-demo.sh | bash
    ```

1. **Explore Keptn!** Please have a look at our [tutorials](https://tutorials.keptn.sh) and [documentation](../) to learn how you can use Keptn.


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
