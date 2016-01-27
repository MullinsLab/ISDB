# Integration diagrams

HIV starts as single-stranded RNA diagramed like so:

     HIV  5aʹ~GAG~~~ENV~3aʹ

When reverse transcribed into double-stranded DNA, it looks like:

     HIV  5aʹ~GAG~~~ENV~3aʹ
          3bʹ~GAG~~~ENV~5bʹ

There are two orientations this double-stranded HIV DNA may be integrated into
genomic DNA as a provirus:

                        HIV
     Chr  1 ---- 5aʹ~GAG~~~ENV~3aʹ ---- N
          1 ---- 3bʹ~GAG~~~ENV~5bʹ ---- N
     
                        HIV
     Chr  1 ---- 5bʹ~ENV~~~GAG~3bʹ ---- N
          1 ---- 3aʹ~ENV~~~GAG~5aʹ ---- N

The following diagrams form a truth table of provirus orientation with respect
to the chromosome crossed by provirus orientation with respect to the gene.
Pay careful attention to the location of GAG and ENV (or 5aʹ vs. 5bʹ).

## Provirus is _forward_ with respect to the chromosome…

### …and _forward_ with respect to the gene

             Gene is forward with
             respect to chromosome
             |——————→
     Chr  1 ---- 5aʹ~GAG~~~ENV~3aʹ ---- N
          1 ---- 3bʹ~GAG~~~ENV~5bʹ ---- N

### …and _reverse_ with respect to the gene

     Chr  1 ---- 5aʹ~GAG~~~ENV~3aʹ ---- N
          1 ---- 3bʹ~GAG~~~ENV~5bʹ ---- N
                             ←——————| Gene is reverse with
                                      respect to chromosome

## Provirus is _reverse_ with respect to the chromosome…

### …and _forward_ with respect to the gene

     Chr  1 ---- 5bʹ~ENV~~~GAG~3bʹ ---- N
          1 ---- 3aʹ~ENV~~~GAG~5aʹ ---- N
                             ←——————| Gene is reverse with
                                      respect to chromosome

### …and _reverse_ with respect to the gene

             Gene is forward with
             respect to chromosome
             |——————→
     Chr  1 ---- 5bʹ~ENV~~~GAG~3bʹ ---- N
          1 ---- 3aʹ~ENV~~~GAG~5aʹ ---- N
