SHELL := /bin/bash
export SHELLOPTS:=errexit:pipefail
.DELETE_ON_ERROR:

PATH := ../../bin:$(PATH)

all: ncbi_genes.sql

Homo_sapiens.gene_info.gz:
	wget -Nc ftp://ftp.ncbi.nih.gov/gene/DATA/GENE_INFO/Mammalia/$@

ncbi_genes.sql: Homo_sapiens.gene_info.gz
	echo "-- Source: $<" > $@
	perl -le 'print "-- Modified: " . localtime((stat shift)[9])' $< >> $@
	echo "-- Generated: `date`" >> $@
	(gunzip -c $< || test $$? -eq 2) | ncbi-gene-to-sql >> $@
