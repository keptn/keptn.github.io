
VOLUMES := -v $(CURDIR):/src -v $(CURDIR)/public:/target 
IMAGE := klakegg/hugo:0.105.0-ext

.PHONY: build server clean htmltest

build:
	docker run --rm -it $(VOLUMES) $(IMAGE) -D -v

server:
	docker run --rm -it $(VOLUMES) -p 1313:1313 $(IMAGE) server -D

clean:
	docker run --rm -it $(VOLUMES) $(IMAGE) --cleanDestinationDir

htmltest:
	docker run -v $(CURDIR):/test --rm wjdp/htmltest -s -c .htmltest.yml public
