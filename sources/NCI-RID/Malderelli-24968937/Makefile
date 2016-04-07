SHELL := /bin/bash
export SHELLOPTS:=errexit:pipefail
.DELETE_ON_ERROR:

dups.csv: identify-dups.sql identify-dups
	psql -qAF, $${PGDATABASE:-isdb} < $< | perl -ne 'print unless eof' \
		| recs fromcsv --header \
		| ./identify-dups \
		| recs tocsv -k subject,landmark,location,orient,ltr,multiplicity \
		> $@
