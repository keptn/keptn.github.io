
VOLUMES := -v $(CURDIR):/src -v $(CURDIR)/public:/target 
IMAGE := klakegg/hugo:0.53-ext-alpine

.PHONY: build server clean htmltest markdownlint markdownlint-fix

build:
	docker run --rm -it $(VOLUMES) $(IMAGE) -D -v

server:
	docker run --rm -it $(VOLUMES) -p 1313:1313 $(IMAGE) server -D

clean:
	docker run --rm -it $(VOLUMES) $(IMAGE) --cleanDestinationDir

htmltest:
	docker run -v $(CURDIR):/test --rm wjdp/htmltest -s -c .htmltest.yml public

markdownlint:
	docker run -v $(CURDIR):/workdir --rm  ghcr.io/igorshubovych/markdownlint-cli:latest  "**/*.md"

markdownlint-fix:
	docker run -v $(CURDIR):/workdir --rm  ghcr.io/igorshubovych/markdownlint-cli:latest  "**/*.md" --fix
