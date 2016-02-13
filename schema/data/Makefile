SHELL := /bin/bash
export SHELLOPTS:=errexit:pipefail
.DELETE_ON_ERROR:

ref_GRCh38.p2_top_level.gff3.gz:
	wget -Nc ftp://ftp.ncbi.nlm.nih.gov/genomes/Homo_sapiens/GFF/$@

chr_accessions_GRCh38.p2:
	wget -Nc ftp://ftp.ncbi.nlm.nih.gov/genomes/Homo_sapiens/Assembled_chromosomes/$@
