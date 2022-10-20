.PHONY: clean repro

clean:
	sudo chown -R $(USER):$(USER) data && \
		rm -rf $(CURDIR)/data/.erlang.cookie $(CURDIR)/data/mnesia $(CURDIR)/log/rabbit.log
	docker image rm feature-flags-test || true

repro:
	$(CURDIR)/repro.sh
