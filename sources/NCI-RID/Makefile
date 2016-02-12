SHELL := /bin/bash
export SHELLOPTS:=errexit:pipefail
.DELETE_ON_ERROR:

ISDB := ../..

transformed-GRCh37.csv: source.tsv
	./transform $< > $@

transformed.csv: transformed-GRCh37.csv
	$(ISDB)/bin/liftover hg19 hg38 $< | ./tocsv > $@

orphaned.csv: transformed-GRCh37.csv transformed.csv
	./orphans $^ > $@

source.tsv:
	./download > $@
