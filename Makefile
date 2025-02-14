SECRETS := $(shell readlink -f ./.env)

all: alertmanager.yml prometheus/prometheus.yml

alertmanager.yml: alertmanager.yml.in $(SECRETS)
	@test -f $(SECRETS) ; set -a ; source $(SECRETS) ; envsubst < $< > $@

prometheus/prometheus.yml: prometheus/prometheus.yml.in
	@test -f $(SECRETS) ; set -a ; source $(SECRETS) ; envsubst < $< > $@
	docker run -v $(shell pwd)/prometheus:/pingprom:rw -it --entrypoint=promtool prom/prometheus check config /pingprom/prometheus.yml

clean:
	rm alertmanager.yml prometheus/prometheus.yml
