SHELL := /bin/bash
export SHELLOPTS:=errexit:pipefail
.DELETE_ON_ERROR:

ISDB := ../..

integrations-GRCh37.csv: source.tsv
	./transform $< > $@

integrations.csv: integrations-GRCh37.csv
	$(ISDB)/bin/liftover hg19 hg38 $< | $(ISDB)/bin/collapse-dual-ltr-records | ./tocsv > $@

orphaned.bed: integrations.csv
	# Running liftover to produce integrations.csv also produces orphaned.bed

orphaned.csv: integrations-GRCh37.csv orphaned.bed
	./orphans $^ > $@

source.tsv:
	./download > $@
