---
title: What is keptn?
description: The overall goal of keptn is to make continuous delivery and operations automation a commodity for modern cloud-native applications.
weight: 10
keywords: [keptn, cloud-native, cd]
---

The overall goal of keptn is to make continuous delivery and operations automation a commodity for modern cloud-native applications. 

Keptn was started by Dynatrace because we saw that continuous delivery—as it’s currently practiced—is broken. We’re on a mission to solve the biggest problems of continuous delivery that exist today. 

## The problem - Too much work 

Today most companies build their continuous delivery and operations pipelines by hand. Often these pipelines vary from application to application. This can lead to a lot of manual work in building the required delivery mechanisms for cloud-native applications. 

**The solution - Automate the plumbing**

Keptn uses a simple, declarative approach that allows you to specify what you want your continuous delivery pipelines to look like, using so-called “shipyard files.” These files are used to automatically generate all the required plumbing that underlies your delivery pipeline. A multi-stage pipeline can be set up from scratch in ten minutes or less. Keptn is like Kubernetes, but for your continuous delivery pipeline.

## The problem - Maintainability is too low

Delivery pipelines and operations automation are often built ad-hoc. Code is spread across numerous tools and, afterall, there is no continuous delivery process for continuous delivery pipelines (did someone say “Inception”?). For these reasons, DevOps automation code is likely to become the next big legacy code.

**The solution - Separate the control plane from the actual tool plumbing**

Keptn uses well-defined Cloud Events for pretty much everything that can happen during continuous delivery and operations automation. Knative services register these events and then translate them into API calls for specific tools. Keptn acts as a central control plane for continuous delivery, putting all your automation code in one place, as well as separating tool integrations from the definition of continuous delivery “applications.”

## The problem - Massive vendor lock-in

As most tool integrations today are done on a 1:1 basis based on proprietary APIs, many companies face vendor lock-in when it comes to their continuous delivery pipelines and operations automation. It can be nearly impossible to replace these tools in many instances. Even if you can replace a tool, a massive amount of work is required and you risk taking your delivery automation offline for a period of time. 

**The solution - Provide standards for building continuous delivery**

Keptn integrations are merely translations of well-defined Cloud Events into proprietary vendor APIs. This makes exchanging tools much easier from a continuous delivery perspective. Keptn, for example, uses a new artifact event instead of requiring a direct integration to container registries, and it issues deployment events rather than directly calling deployment tools. All tool integrations are defined in uniform files which allow for the building of “integrations-as-code”

## The problem - Heavy runtime footprint

Most continuous delivery and operations automation solutions have large runtime requirements, especially within enterprise settings. Most tools also consume resources even when they’re idle, either because no deployment is currently active or operations actions are still running.

**The solution - keptn is fully serverless**

Keptn is built on Knative serverless services, so components only consume resources when they are actively doing something. This massively reduces the costs of running continuous delivery pipelines. With keptn you can run an enterprise-grade continuous delivery and operations automation layer from your laptop for less than the cost of a burger and fries.

## The problem - Auditing for continuous delivery and operations is hard

There are a lot of operations management and workflow solutions out there that provide auditing. However, most of this auditing visibility breaks once you move towards customized tool integrations. Suddenly, understanding the cause and effect of actions taken by your platform becomes a mystery. 

**The solution - keptn provides tracing for continuous delivery and operations automation**

Keptn was created by Dynatrace, the inventor of distributed transaction tracing. So it should be no surprise that we’ve embedded tracing capabilities into keptn. All cloud events in keptn use the W3C trace context headers. This enables the stitching together of individual actions into traces. This represents a new level of visibility into your continuous delivery pipeline that wasn’t previously possible.
