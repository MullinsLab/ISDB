SHELL := /bin/bash
export SHELLOPTS:=errexit:pipefail
.DELETE_ON_ERROR:

ISDB := ../..

transformed-GRCh37.csv: 12977_2013_3591_MOESM2_ESM
	./transform $< > $@

transformed.csv: transformed-GRCh37.csv
	$(ISDB)/bin/liftover hg19 hg38 $< | ./tocsv > $@
