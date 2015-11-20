# Input requirements for the IS database

* All chromosomes and locations must be provided in __GRCh38__ (hg19)
  coordinates and determined without using patch scaffolds (fix or novel) from
  patch releases.  This provides portability and longevity of integration sites
  and makes analysis simpler.  When a new major assembly is released, lifting
  over coordinates will be easier without the use of patch scaffolds.

* Locations must number the space between bases (interbase) and start from 0,
  to the left of the first base.

* Gene names must use [NCBI Gene](http://www.ncbi.nlm.nih.gov/gene/) names,
  which are available in GFF format from the Genome Reference Consortium.

* Orientation must be reported as `F` or `R`.

* The sequence spanning the IS must read 5' → 3', right to left.

  XXX TODO: Is this reasonable, or useful?  Not sure.  I need to diagram it.
  -trs, 20 Nov 2015

* The location of the HIV/human genome junction in any reported sequence must
  number the space between bases (interbase) and start from 0.
