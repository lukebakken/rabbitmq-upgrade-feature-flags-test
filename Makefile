.PHONY: clean repro

clean:
	sudo chown -R $(USER):$(USER) data log && \
		rm -rf $(CURDIR)/data/.erlang.cookie $(CURDIR)/data/mnesia $(CURDIR)/log/rabbit.log
	docker container rm -f feature-flags-test || true

repro: clean
	$(CURDIR)/repro.sh
