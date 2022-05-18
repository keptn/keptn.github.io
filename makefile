
VOLUMES := -v $(CURDIR):/src -v $(CURDIR)/public:/target 

build:
	docker run --rm -it $(VOLUMES) klakegg/hugo:0.53-ext -D -v

server:
	docker run --rm -it $(VOLUMES) -p 1313:1313 klakegg/hugo:0.53-ext server -D

clean:
	docker run --rm -it $(VOLUMES) klakegg/hugo:0.53-ext --cleanDestinationDir

htmltest:
	docker run -v $(CURDIR):/test --rm wjdp/htmltest -c .htmltest.yml public
