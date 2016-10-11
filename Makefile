SHELL := /bin/bash
export SHELLOPTS:=errexit:pipefail
.DELETE_ON_ERROR:

SYS  := $(shell uname -s)
ARCH := $(shell uname -m)

ifeq ($(SYS), Darwin)
OS := macOSX
else ifeq ($(SYS), Linux)
OS := linux
else
OS := $(SYS)
endif

cpanm := bin/cpanm

curl := curl -fsSL

deps: $(cpanm) liftover perl-deps hg-data

perl-deps: cpanfile
	mkdir -p local
	$(cpanm) --quiet --from https://cpan.metacpan.org/ --no-lwp --notest -l local --installdeps .

$(cpanm):
	$(curl) https://raw.githubusercontent.com/miyagawa/cpanminus/master/cpanm > $@
	chmod +x $@

liftover: bin/liftOver.$(SYS) cache/hg19ToHg38.over.chain.gz

bin/liftOver.$(SYS):
	$(curl) http://hgdownload.soe.ucsc.edu/admin/exe/$(OS).$(ARCH)/liftOver > $@
	chmod +x $@

cache/hg19ToHg38.over.chain.gz:
	mkdir -p cache
	$(curl) http://hgdownload.cse.ucsc.edu/goldenPath/hg19/liftOver/$(notdir $@) > $@

hg-data: schema/data/ref_GRCh38.p2_top_level.gff3.gz schema/data/chr_accessions_GRCh38.p2

schema/data/ref_GRCh38.p2_top_level.gff3.gz:
	$(curl) https://ftp.ncbi.nlm.nih.gov/genomes/H_sapiens/ARCHIVE/ANNOTATION_RELEASE.107/GFF/$(notdir $@) > $@

schema/data/chr_accessions_GRCh38.p2:
	$(curl) https://ftp.ncbi.nlm.nih.gov/genomes/H_sapiens/ARCHIVE/ANNOTATION_RELEASE.107/Assembled_chromosomes/$(notdir $@) > $@
