SHELL := /bin/bash
export SHELLOPTS:=errexit:pipefail
.DELETE_ON_ERROR:

transformed.csv: Wang_bed_hg38.txt
	./transform $< > $@
