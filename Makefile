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

liftover: bin/liftOver.$(SYS) cache/hg19ToHg38.over.chain.gz

bin/liftOver.$(SYS):
	wget http://hgdownload.soe.ucsc.edu/admin/exe/$(OS).$(ARCH)/liftOver -O $@
	chmod +x $@

cache/hg19ToHg38.over.chain.gz:
	mkdir -p cache
	cd cache && wget -Nc http://hgdownload.cse.ucsc.edu/goldenPath/hg19/liftOver/$(notdir $@)
