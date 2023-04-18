---
title: Home
---



{{< blocks/cover title="Keptn" image_anchor="top" height="half" color="primary" >}}
<div class="mx-auto">

<div>

## Cloud-native application life-cycle orchestration

</div>
<div style="text-align: left">

### Keptn automates

- Observability, dashboards & alerting
- SLO-driven multi-stage delivery 
- Operations & remediation

declarative, extensible and based on GitOps

<a class="btn btn-lg mr-3 mb-4 -bg-green -text-white"
    href="https://keptn.sh/docs/quickstart/">
    Install Keptn!<i class="fas fa-arrow-alt-circle-right ml-2"></i>
</a>
 <a class="btn btn-lg btn-secondary mr-3 mb-4" href="{{< relref "/docs" >}}">
  Docs <i class="fas fa-arrow-alt-circle-right ml-2"></i>
 </a>
</div>
</div>
<picture>
    <source media="(min-width: 768px)" srcset="/images/home/hero/graphic-hero.svg">
    <img src="/images/home/hero/graphic-hero-XS.svg">
</picture>


{{< /blocks/cover >}}

{{% blocks/lead color="light" %}}

<div>
{{% readfile "home/usage.md" %}}
</div>
{{% /blocks/lead %}}

{{< blocks/lead color="primary" >}}
<div>
{{% readfile "home/delivery.md" %}}
</div>
<a class="btn btn-lg mr-3 mb-4 -bg-green -text-white" href="https://keptn.sh/docs/quickstart/">
    Start now!
</a>
 <a class="btn btn-lg btn-secondary mr-3 mb-4" href="{{< relref "/docs" >}}">
  Read Docs <i class="fas fa-arrow-alt-circle-right ml-2"></i>
 </a>
<picture width="100%">
    <source media="(min-width: 768px)" srcset="/images/home/use-cases/graphic-use-case-02.svg">
    <source media="(min-width: 576px)" srcset="/images/home/use-cases/graphic-use-case-02-S.svg">
    <img src="/images/home/use-cases/graphic-use-case-02-XS.svg">
</picture>
{{% /blocks/lead %}}

{{< blocks/lead color="secondary" >}}
<div>
{{% readfile "home/remediation.md" %}}
</div>

<a class="btn btn-lg mr-3 mb-4 -bg-green -text-white" href="https://keptn.sh/docs/quickstart/">
    Start now!
</a>
 <a class="btn btn-lg btn-secondary mr-3 mb-4" href="{{< relref "/docs" >}}">
  Read Docs <i class="fas fa-arrow-alt-circle-right ml-2"></i>
 </a>
<div class="container">
<div class="row">
    <div class="col">
    <picture>
        <source media="(min-width: 768px)" srcset="/images/home/use-cases/graphic-use-case-03a.svg">
        <img class="" src="/images/home/use-cases/graphic-use-case-03-XS.svg">
    </picture>
    </div>
    <div class="col">
    <picture>
        <img src="/images/home/use-cases/graphic-use-case-03b.svg">
    </picture>
    </div>
</div>
</div>

{{% /blocks/lead %}}

{{< blocks/section color="dark">}}
{{% blocks/feature icon="capability01 capability" title="Declarative automation" %}}
Multi-stage delivery without the need to write any pipeline code.
{{% /blocks/feature %}}
{{% blocks/feature icon="capability02 capability" title="GitOps based" %}}
Delivery and operation workflows are based on Git.
{{% /blocks/feature %}}
{{% blocks/feature icon="capability03 capability" title="SLO driven evaluation" %}}
Built-in quality-gates based on SRE principles.
{{% /blocks/feature %}}
{{% blocks/feature icon="capability04 capability" title="Closed-loop remediation" %}}
Multi-step Auto-remediation workflows with built-in evaluation.
{{% /blocks/feature %}}
{{% blocks/feature icon="capability05 capability" title="Standard-based Interoperability" %}}
Integrate or extend Keptn easily to work with your tool-suite.
{{% /blocks/feature %}}

{{% /blocks/section %}}