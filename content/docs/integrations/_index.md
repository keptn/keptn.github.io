---
title: Integrations
description: See all integrations available for Keptn and maintained by the community.
icon: setup
weight: 1001
hidechildren: true # this flag hides all sub pages in the sidebar-multicard.html
---

## Available integrations

Keptn as a control-plane integrates with various different tools and can be extended with your own tools.
In the following you'll find integrations that are already provided by the Keptn team and its community.

Scroll to the bottom of this page to request a new integration or submit your own.

{{< rawhtml >}}
<input id="services-search" type="text" placeholder="Search">
<button class="btn filterBtn" value="show-all">Show all</button>
<button class="btn filterBtn" value="testing">Testing</button>
<button class="btn filterBtn" value="deployment">Deployment</button>
<button class="btn filterBtn" value="observability">Observability</button>
<button class="btn filterBtn" value="webhook">Webhook</button>
<button class="btn filterBtn" value="notification">Notification</button>
<button class="btn filterBtn" value="remediation">Remediation</button>
<button class="btn filterBtn" value="sli-provider">SLI Providers</button>

<script type="text/javascript">
    const input = document.getElementById("services-search");
    const groups = document.getElementsByClassName('artifacthub-widget-group');
    let timeout = null;

    const inputHandler = function(e) {
        if (timeout) {
            clearTimeout(timeout);
        }

        timeout = setTimeout(() => {
            const search = input.value.toLowerCase();
            groups[0].dataset.url = `https://artifacthub.io/packages/search?kind=10&sort=relevance${search !== '' ? `&ts_query_web=${search}` : ''}`;
        }, 400);
    }
    input.addEventListener('input', inputHandler)

    let btns = document.getElementsByClassName("filterBtn");
    for (let i = 0; i < btns.length; i++) {
      btns[i].addEventListener("click", function() {
          let filterValue = btns[i].value.toLowerCase();
          groups[0].dataset.url = `https://artifacthub.io/packages/search?kind=10&sort=relevance${filterValue !== '' && filterValue !== 'show-all' ? `&ts_query_web=${filterValue}` : ''}`;
      });
    }

</script>
<div class="artifacthub-widget-group" data-url="https://artifacthub.io/packages/search?kind=10&sort=relevance&page=1&ts_query_web=" data-theme="light" data-header="false" data-color="#417598" data-stars="false" data-responsive="true" data-loading="true"></div><script async src="https://artifacthub.io/artifacthub-widget.js"></script>
{{< /rawhtml >}}

### Request a New Integration

Need support for a new tool which isn't listed above? Start by [creating an issue here](https://github.com/keptn/integrations/issues/new?assignees=&labels=integrations&template=integration_template.yaml&title=%5Bintegration%5D+).

### Contributing

- Identified a bug? Please create an issue in the relevant repository (not the [main Keptn repo](https://github.com/keptn/keptn)) or speak to us on [Slack](https://slack.keptn.sh).

- Want to submit an integration you have developed? Start by [creating an issue here](https://github.com/keptn/integrations/issues/new?assignees=&labels=integrations&template=integration_template.yaml&title=%5Bintegration%5D+).

- Developing an integration and need help? Join the `#keptn-integrations` channel on [Slack](https://slack.keptn.sh).

- Can your tool be triggered via a webhook? Keptn can orchestrate it with zero development using the out-of-the-box webhook service.
  
- Can your tool be containerised? The [job executor service](https://github.com/keptn-contrib/job-executor-service) can run your container.

- If your tool is deployed outside a container, there are options for integration. Please reach out to discuss on [Slack](https://slack.keptn.sh).