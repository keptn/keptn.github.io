---
title: Keptn 1.3.0
weight: 61
---

## [1.3.0](https://github.com/keptn/keptn/compare/1.2.0...1.3.0) (2023-04-05)


### Features

* **bridge:** Add support for NodeJS18 introducing a caching dir on an emptydir volume ([#9582](https://github.com/keptn/keptn/issues/9582)) ([6cee52c](https://github.com/keptn/keptn/commit/6cee52ced8c5814a2e8613176f27dc2508bbed9a))
* **installer:** add image pull secrets support ([#9513](https://github.com/keptn/keptn/issues/9513)) ([2edebfc](https://github.com/keptn/keptn/commit/2edebfcdcad8b1d5c3b7ee9d4e3f96ab71605543))


### Bug Fixes

* added mongo secrets as volumes ([#9524](https://github.com/keptn/keptn/issues/9524)) ([8411f4a](https://github.com/keptn/keptn/commit/8411f4af63fbe54f07931de422558eb4f5cc0645))
* **installer:** add missing NATS init container to API service ([#9534](https://github.com/keptn/keptn/issues/9534)) ([d67caaa](https://github.com/keptn/keptn/commit/d67caaa858580ed89127fbc2cadb5a3ed0bab10b))
* **installer:** Add MongoDB init container iff there is no external connection string ([#9546](https://github.com/keptn/keptn/issues/9546)) ([a888650](https://github.com/keptn/keptn/commit/a88865013512aa27ebfcf90a6cf1e5b7f2dfaad6))
* **resource-service:** continue with stage creation if a refNotFound error is encountered ([#9553](https://github.com/keptn/keptn/issues/9553)) ([aa0c588](https://github.com/keptn/keptn/commit/aa0c588500c7a9745ddfa755a7a742c36399ce80))
* security pipeline ([#9597](https://github.com/keptn/keptn/issues/9597)) ([90b9b26](https://github.com/keptn/keptn/commit/90b9b26b0b0b2899c5cea0788ab38ce0079807be))


### Docs

* add AlexsJones and AnaMMedina21 as maintainers ([#9515](https://github.com/keptn/keptn/issues/9515)) ([b98ab55](https://github.com/keptn/keptn/commit/b98ab554f6d274eda16cf90d12331df372f8353d))


### Other

* change [@thschue](https://github.com/thschue) affiliation ([#9601](https://github.com/keptn/keptn/issues/9601)) ([17e6e01](https://github.com/keptn/keptn/commit/17e6e01ddd608226bae82fd5800405db95e5d61b))
* Fix security checks - allow resource-service to read secrets ([#9588](https://github.com/keptn/keptn/issues/9588)) ([7bb423b](https://github.com/keptn/keptn/commit/7bb423bce530d67a64d02048053dfa50b7c02635))
* Move adopters page to community repo ([#9552](https://github.com/keptn/keptn/issues/9552)) ([e871bac](https://github.com/keptn/keptn/commit/e871bacc253e9e9b8e66b177bcc6f7a66ab07247))
* move away from docker ([#9576](https://github.com/keptn/keptn/issues/9576)) ([8df9bcf](https://github.com/keptn/keptn/commit/8df9bcff83d0b67fdf9b4aee4ba65da60beea1a8))
* update go.mod and pipeline to use the same Go version of Dockerfile ([#9535](https://github.com/keptn/keptn/issues/9535)) ([7e3a3ab](https://github.com/keptn/keptn/commit/7e3a3ab71bddcd41ebd5640b7fe2815eff9cbb00))