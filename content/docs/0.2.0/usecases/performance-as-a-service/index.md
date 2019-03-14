---
title: Performance as a Service
description: Shows you how to setup a fully automated on-demand self-service model for performance testing.
weight: 20
keywords: [quality gates]
aliases:
---

This use case shows how to setup a fully automated on-demand self-service model for performance testing.

## About this use case

In the previous use case *Onboarding the Carts Service* the carts service has been onboarded to a keptn managed project and has been deployed in a three-staged environment.  The goal of this use case is to provide an automated performance testing model for developers to run a performance test for the carts service on demand. This supports the implementation of an advanced DevOps approach due to early performance feedback regarding a service in a development environment and before it gets deployed into a production environment. All in all, this helps to move from manual sporadic execution and analysis of performance tests to a fully automated on-demand self-service model for developers.

To illustrate the scenario this use case addresses, you will change the carts service that gets deployed to the dev environment. Eager to understand the performance characteristics of this new deployment, you trigger a performance test. However, this performance test fails due to a quality gate in place. To investigate the issues resulting in this failed performance test, you will use a monitoring solution that allows a comparison of test load.

