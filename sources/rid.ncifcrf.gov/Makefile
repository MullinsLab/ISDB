SHELL := /bin/bash
export SHELLOPTS:=errexit:pipefail
.DELETE_ON_ERROR:

.PHONY: source.tsv
source.tsv:
	./download > $@
