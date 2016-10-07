SHELL := /bin/bash
export SHELLOPTS:=errexit:pipefail
.DELETE_ON_ERROR:

ref_GRCh38.p2_top_level.gff3.gz:
	wget -Nc https://ftp.ncbi.nlm.nih.gov/genomes/H_sapiens/ARCHIVE/ANNOTATION_RELEASE.107/GFF/$@

chr_accessions_GRCh38.p2:
	wget -Nc https://ftp.ncbi.nlm.nih.gov/genomes/H_sapiens/ARCHIVE/ANNOTATION_RELEASE.107/Assembled_chromosomes/$@
