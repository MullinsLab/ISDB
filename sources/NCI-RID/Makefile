SHELL := /bin/bash
export SHELLOPTS:=errexit:pipefail
.DELETE_ON_ERROR:

ISDB := ../..

integrations-GRCh37.csv: source.tsv
	./transform $< > $@

integrations.csv: integrations-GRCh37.csv
	$(ISDB)/bin/liftover hg19 hg38 $< | ./tocsv > $@

orphaned.csv: integrations-GRCh37.csv integrations.csv
	./orphans $^ > $@

source.tsv:
	./download > $@
