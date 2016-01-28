% Mullins Integration Site Database
% Mullins Molecular Retrovirology Lab
% 2016

The Integration Site Database aims to provide a stable, authoritative, and standardized
source of data for analysing HIV-1 integration sites. It seeks to
support analyses using the tools of your choice, whether that's R and
ggplot or Excel and Prism.

The data contained within comes from a variety of sources external and internal
to the [Mullins Lab](https://mullinslab.microbiol.washington.edu), [Frenkel
Lab](https://www.seattlechildrens.org/research/global-infectious-disease-research/frenkel-lab/),
and our collaborators. The database itself is regularly and automatically
regenerated from our primary and secondary sources in order to incorporate
changes and additions.


# HIV proviral integration

The ISDB's representation of data requires some careful understanding of how reverse-transcribed HIV integrates into human genomic DNA.

HIV starts as single-stranded RNA diagramed like so:

     HIV  5ʹLTR~GAG~~~ENV~3ʹLTR

RNA is single-stranded, so when discussing the HIV genome we naturally label the two long terminal repeat (LTR) regions as the _5ʹ LTR_ and _3ʹ LTR_.

When reverse transcribed into double-stranded DNA, it looks like:

     HIV  5ʹLTR~GAG~~~ENV~3ʹLTR
          5ʹLTR~GAG~~~ENV~3ʹLTR (complementary strand)

There are two orientations this double-stranded HIV DNA may be integrated into
genomic DNA as a provirus:

                        HIV
     Chr  1 ---- 5ʹLTR~GAG~~~ENV~3ʹLTR ---- N
          1 ---- 5ʹLTR~GAG~~~ENV~3ʹLTR ---- N
     
                        HIV
     Chr  1 ---- 3ʹLTR~ENV~~~GAG~5ʹLTR ---- N
          1 ---- 3ʹLTR~ENV~~~GAG~5ʹLTR ---- N

The following diagrams form a truth table of provirus orientation with respect
to the chromosome crossed by provirus orientation with respect to the gene.
Pay careful attention to the location of GAG and ENV (or 5aʹ vs. 5bʹ).

## Provirus is _forward_ with respect to the chromosome…

### …and _forward_ with respect to the gene

             Gene is forward with
             respect to chromosome
             |——————→
     Chr  1 ---- 5ʹLTR~GAG~~~ENV~3ʹLTR ---- N
          1 ---- 5ʹLTR~GAG~~~ENV~3ʹLTR ---- N

### …and _reverse_ with respect to the gene

     Chr  1 ---- 5ʹLTR~GAG~~~ENV~3ʹLTR ---- N
          1 ---- 5ʹLTR~GAG~~~ENV~3ʹLTR ---- N
                                 ←——————| Gene is reverse with
                                          respect to chromosome

## Provirus is _reverse_ with respect to the chromosome…

### …and _forward_ with respect to the gene

     Chr  1 ---- 3ʹLTR~ENV~~~GAG~5ʹLTR ---- N
          1 ---- 3ʹLTR~ENV~~~GAG~5ʹLTR ---- N
                                 ←——————| Gene is reverse with
                                          respect to chromosome

### …and _reverse_ with respect to the gene

             Gene is forward with
             respect to chromosome
             |——————→
     Chr  1 ---- 3ʹLTR~ENV~~~GAG~5ʹLTR ---- N
          1 ---- 3ʹLTR~ENV~~~GAG~5ʹLTR ---- N

# Integration Coordinates

ISDB provides the location of integration splice junctions in _zero-origin, interbase coordinates_. This means that a `location` reported by the database identifies a location _between_ two nucleotides, rather than identifying a nucleotide. These locations are numbered starting with reference position 0, which is to the left/$5^\prime$ of nucleotide 1.

# Integration Summary

The _integration summary_ report contains a row for each integration _event_ in
the database, along with that event's _clonal multiplicity_ as reported by the
source.

| column                     | type                 | example    |
|----------------------------+----------------------+------------|
| `source_name`              | text                 | `NCI-RID`  |
| `subject`                  | text                 | `2`        |
| `ncbi_gene_id`             | integer              | `80208`    |
| `gene`                     | text                 | `SPG11`    |
| `landmark`                 | text                 | `chr5`     |
| `location`                 | non-negative integer | `44642671` |
| `orientation_in_reference` | orientation          | `F`        |
| `orientation_in_gene`      | orientation          | `R`        |
| `multiplicity`             | non-negative integer | `1`        |

## Fields

### `source_name`

A label identifying the source documenting the integration event in this row.

### `subject`

A label identifying the studied individual whose cells contained this integration event.

### `ncbi_gene_id`

The ID number of the gene annotated at the integration site (if any) in the NCBI Gene database.

### `gene`

The name of the gene annotated at the integration site (if any).

### `landmark`

A chromosome label like `chr5`, `chr19`, or `chrX`, identifying the chromosome of the human genome the integration site maps to, or else a RefSeq accession number identifying a non-chromosome reference landmark.

### `location`

The location of the integration splice junction, in 0-origin, interbase coordinates.

### `multiplicity`

The _number of independent observations_ of this integration event within this source. Generally, we expect that if an event is observed more than once, the method used suggests clonal proliferation of a cell with integrated provirus at that site. We will endeavor _not_ to count technical replicates identifying the same integration site as an indication of multiplicity. For instance, if the ISLA reaction were performed in triplicate on cells from a single ICE culture, finding the same IS in all replicates, that data contributes a multiplicity of 1 rather than 3 due to the nature of the ICE protocol.

# Summary by gene

The _summary by gene_ report counts integration sites appearing in annotated genes across various subjects, sources, and locations.

| column          | type    | example |
|-----------------+---------+---------|
| `ncbi_gene_id`  | integer | `80208` |
| `gene`          | text    | `SPG11` |
| `subjects`      | integer | `12`    |
| `unique_sites`  | integer | `14`    |
| `total_in_gene` | integer | `29`    |


## Fields

### `ncbi_gene_id`, `gene`

The annotated gene for which integrations are being summarized.

### `subjects`

The number of distinct subjects (presumably human HIV+ patients) with latent HIV integrated anywhere in this gene.

### `unique_sites`

The number of distinct nucleotide positions within this gene where HIV has been found to integrate. Multiplicity is ignored.

### `total_in_gene`

The _total number of independent observations_ of integrations into this gene. This number is equal to the sum of `multiplicity` from each row of `integration_summary` annotated with this `gene`, so it should _exclude_ technical replicates.

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

* The sequence spanning the IS must read $5^\prime$ → $3^\prime$, right to left.

* The location of the HIV/human genome junction in any reported sequence must
  number the space between bases (interbase) and start from 0.

# Developer documentation

The remaining sections in this document are less complete, and aimed at the developers of ISDB and tools to load data from outside sources. Directly using the primary `integration` table will be unnecessary for many analysis tasks. Here be dragons, et cetera.

## Types

`ltr_end`
  ~ An alias of `text` indicating an end of HIV's viral RNA genome. One of `5p` (for the $5^\prime$ LTR), `3p` (for the $3^\prime$ LTR).

`orientation`
  ~ _Orientation_ is `F` (for _forward_)  when the $5^\prime \rightarrow 3^\prime$ reading direction of the positive strand of integrated HIV matches the reading direction of a surrounding feature, and `R`  when the positive strand is _reversed_.


## The `integration` table

The primary fact table in ISDB is `integration`. Each row records _an occurence_ of an HIV provirus being detected at the given integration site in the given subject by the given source.

| column                     | type                   |
| ---------                  | -----------            |
| `source_name`              | `varchar(255)`         |
| `sample`                   | `jsonb`                |
| `ltr`                      | `ltr_end`              |
| `refseq_accession`         | `varchar(255)`         |
| `chromosome`               | `human_chromosome`     |
| `location`                 | non-negative `integer` |
| `orientation_in_reference` | `orientation`          |
| `orientation_in_gene`      | `orientation`          |
| `ncbi_gene_id`             | `integer`              |
| `sequence`                 | `text`                 |
| `sequence_junction`        | non-negative `integer` |
| `note`                     | `text`                 |
| `info`                     | `jsonb`                |
