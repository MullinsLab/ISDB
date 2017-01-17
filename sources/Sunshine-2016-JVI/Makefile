SHELL := /bin/bash
export SHELLOPTS:=errexit:pipefail
.DELETE_ON_ERROR:

ISDB := ../..
data := $(wildcard data/*/sites/*.sites)

integrations-GRCh37.csv: $(data)
	./transform $^ > $@

integrations.csv: integrations-GRCh37.csv
	$(ISDB)/bin/liftover hg19 hg38 $< | $(ISDB)/bin/collapse-dual-ltr-records --sample-key sample/tissue | ./tocsv > $@
