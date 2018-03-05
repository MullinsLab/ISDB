SHELL := /bin/bash
export SHELLOPTS:=errexit:pipefail
.DELETE_ON_ERROR:

SYS  := $(shell uname -s)
ARCH := $(shell uname -m)

PANDOC_VERSION ?= 2.1.1

ifeq ($(SYS), Darwin)
LIFTOVER_SYS   := macOSX
PANDOC_PKG     := pandoc-$(PANDOC_VERSION)-macOS.zip
PANDOC_EXTRACT := unzip -DD -o
else ifeq ($(SYS), Linux)
LIFTOVER_SYS   := linux
PANDOC_PKG     := pandoc-$(PANDOC_VERSION)-linux.tar.gz
PANDOC_EXTRACT := tar xzvmf
else
LIFTOVER_SYS := $(SYS)
endif

cpanm := bin/cpanm

curl := curl -fsSL

deps: $(cpanm) pandoc liftover perl-deps hg-data

perl-deps: cpanfile
	mkdir -p local
	$(cpanm) --quiet --from https://cpan.metacpan.org/ --no-lwp --notest -l local --installdeps .

$(cpanm):
	$(curl) https://raw.githubusercontent.com/miyagawa/cpanminus/master/cpanm > $@
	chmod +x $@

pandoc: bin/pandoc

bin/pandoc: cache/pandoc-$(PANDOC_VERSION)/bin/pandoc
	ln -snvf ../$< $@

cache/pandoc-$(PANDOC_VERSION)/bin/pandoc: cache/$(PANDOC_PKG)
	cd cache && $(PANDOC_EXTRACT) $(<:cache/%=%) $(@:cache/%=%)
	chmod +x $@

cache/$(PANDOC_PKG):
	mkdir -p cache
	$(curl) https://github.com/jgm/pandoc/releases/download/$(PANDOC_VERSION)/$(PANDOC_PKG) > $@

liftover: bin/liftOver.$(SYS) cache/hg19ToHg38.over.chain.gz

bin/liftOver.$(SYS):
	@echo "Before downloading liftOver from UCSC, please be advised that"
	@echo "commercial use requires a license."
	@echo
	@echo "Type Ctrl-C (^C) to abort or enter to proceed."
	@read
	$(curl) http://hgdownload.soe.ucsc.edu/admin/exe/$(LIFTOVER_SYS).$(ARCH)/liftOver > $@
	chmod +x $@

cache/hg19ToHg38.over.chain.gz:
	mkdir -p cache
	$(curl) http://hgdownload.cse.ucsc.edu/goldenPath/hg19/liftOver/$(notdir $@) > $@

hg-data: schema/data/ref_GRCh38.p2_top_level.gff3.gz schema/data/chr_accessions_GRCh38.p2 schema/data/Homo_sapiens.gene_info.gz

schema/data/ref_GRCh38.p2_top_level.gff3.gz:
	$(curl) https://ftp.ncbi.nlm.nih.gov/genomes/H_sapiens/ARCHIVE/ANNOTATION_RELEASE.107/GFF/$(notdir $@) > $@

schema/data/chr_accessions_GRCh38.p2:
	$(curl) https://ftp.ncbi.nlm.nih.gov/genomes/H_sapiens/ARCHIVE/ANNOTATION_RELEASE.107/Assembled_chromosomes/$(notdir $@) > $@

schema/data/Homo_sapiens.gene_info.gz:
	$(curl) https://ftp.ncbi.nlm.nih.gov/gene/DATA/GENE_INFO/Mammalia/$(notdir $@) > $@
