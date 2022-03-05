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

{{< rawhtml >}}
<input id="services-search" type="text" placeholder="Search">
<button class="btn filterBtn" value="show-all">Show all</button>
<button class="btn filterBtn" value="testing">Testing</button>
<button class="btn filterBtn" value="deployment">Deployment</button>
<button class="btn filterBtn" value="observability">Observability</button>
<button class="btn filterBtn" value="webhook">Webhook</button>

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

### Contributing

- If you identify a bug you would like to report, please create an issue in the repository of the Keptn-service.

- If you need more information on version compatibility, please go to the repository where a compatibility-matrix should be provided.

- A template for getting started with writing your Keptn service is provided here: https://github.com/keptn-sandbox/keptn-service-template-go

- Please follow the [contributions guide](https://github.com/keptn-sandbox/contributing) for contributing it to Keptn Sandbox.

- The integration overview is managed from the [keptn-sandbox/artifacthub repository](https://github.com/keptn-sandbox/artifacthub). If you have any new integration feel free to add an entry there.
