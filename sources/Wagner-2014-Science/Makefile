SHELL := /bin/bash
export SHELLOPTS:=errexit:pipefail
.DELETE_ON_ERROR:

ISDB := ../..

transformed-GRCh37.csv: 1256304WagnerTableS3-Revised.csv
	./transform $< > $@

transformed.csv: transformed-GRCh37.csv
	$(ISDB)/bin/liftover hg19 hg38 $< | ./tocsv > $@

1256304WagnerTableS3-Revised.csv: %.csv: %.xlsx
	$(ISDB)/bin/explode-csv $<
	# Remove internal newlines in header row
	perl -pe 'chomp if 1 .. 3' < $*/Sheet1.csv > $@
	rm $*/*.csv
	rmdir $*
