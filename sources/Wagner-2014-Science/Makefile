SHELL := /bin/bash
export SHELLOPTS:=errexit:pipefail
.DELETE_ON_ERROR:

ISDB := ../..

1256304WagnerTableS3-Revised.csv: %.csv: %.xlsx
	$(ISDB)/bin/explode-csv $<
	# Remove internal newlines in header row
	perl -pe 'chomp if 1 .. 3' < $*/Sheet1.csv > $@
	rm $*/*.csv
	rmdir $*
