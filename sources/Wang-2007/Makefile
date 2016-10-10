SHELL := /bin/bash
export SHELLOPTS:=errexit:pipefail
.DELETE_ON_ERROR:

integrations.csv: Wang_bed_hg38.txt
	./transform $< > $@
