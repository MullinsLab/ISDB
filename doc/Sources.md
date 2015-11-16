% Source data formats for the IS database

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
