SHELL := /bin/bash
export SHELLOPTS:=errexit:pipefail
.DELETE_ON_ERROR:

transformed.csv: source.tsv
	./transform $< > $@

source.tsv:
	./download > $@
