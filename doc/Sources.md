% Source data formats for the IS database

This document is descriptive, not prescriptive.

# Wenjie's IS tool

id:
    sequence name from FASTA
tag:
    (chromosome)-(location on chromosome)
chromo:
    chromosome of integration site
loc:
    nucleotide position of integration site on chromosome
release:
    identifier for the GRC hg release version
WRT chr:
    orientation of provirus with respect to chromosome. "F" for forward, "R" for reverse
WRT gene:
    orientation of provirus with respect to integrated gene, if any. "F" for forward, "R" for reverse
gene:
    short name of integrated gene, if any (what's the namespace here?)
full name:
    expanded name of integrated gene
description:
    ?
http:
    link to NCBI Gene ID page
sequence:
    portion of query sequence matching hg; LTR junction is removed
qStart:
    nucleotide position in query sequence where start of `sequence` is found
identity:
    `A/B(C)`, where `A` is identical bp between query and hg, `B` is bp of query mapping to hg, `C` is total bp of query including HIV
gaps:
    `A/B(C)`, where `A` is number of gaps introduced mapping query to hg, `B` and `C` as above
note:
    Notes genic/intergenic mapping.


# Excel database

The Excel database compiled by Wenjie, Jim, and others is not used as data
source for the ISDB, but is a useful example of prior work and point of
reference for the datasets involved.

Pt
  ~ Ignore this!
  ~ Patient number, ~sequential with a shared Study prefix (the publication),
    some duplicate numbering of the same Study value

Study
  ~ Patient identifier, usually a combination of publication and published
    patient ID

Gerne [sic, Gene]
  ~ NCBI gene name, LOCNNNNN for an unnamed locus, or NC for Non-Coding

Total
  ~ Number of integrations observed in this gene for this person
  ~ Should be equal to the number of rows for the given (Pt, Study, Gene) tuple
  ~ Only contains a value in one row set of (Pt, Study, Gene) rows

Chr
  ~ Chromosome of integration site (1-22, X, Y)
  ~ `UP` means "unplaced", such as a scaffold not associated with any chromosome

IS
  ~ Nucleotide position of integration site on chromosome

Chr Orient.
  ~ Orientation of provirus with respect to chromosome: `+` for forward, `-` for reverse

Gene Orient.
  ~ Orientation of provirus with respect to integrated gene: `+` for forward, `-` for reverse

Multiplicity
  ~ Number of observed integrations at this (Pt, Study, Gene, Chr, IS)

UpStream gene
  ~ Previous gene or named locus heading 5'-wards on the chromosome
  ~ Should only be present when gene is `NC`

Downstream gene
  ~ Next gene or named locus heading 3'-wards on the chromosome
  ~ Should only be present when gene is `NC`
