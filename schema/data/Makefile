SHELL := /bin/bash
export SHELLOPTS:=errexit:pipefail
.DELETE_ON_ERROR:

Homo_sapiens.gene_info.gz:
	wget -Nc ftp://ftp.ncbi.nih.gov/gene/DATA/GENE_INFO/Mammalia/$@
