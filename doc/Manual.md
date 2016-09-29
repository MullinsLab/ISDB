---
title: Accessing and understanding the data
topic: About data analysis
order: 1
...

This document uses the phrase "an ISDB" to refer in the abstract to any
database created using the ISDB tools and software.  One such example of a
database is [HIRIS][], the Mullins Lab's HIV-1 Reservoirs Integration Sites
database.  You may be working with another database, public or private, also
built using ISDB.

[HIRIS]: https://mullinslab.microbiol.washington.edu/hiris/

# How to use an ISDB

The primary form of an ISDB is a [relational database][reldb] queried using
[SQL](sql).  [PostgreSQL][pg] is the database software we use.  To query an
ISDB directly, you or a colleague will need to connect to the database server
and know how to write SQL.

Since not everyone can write SQL, regular flat-file datasets are made available
for download as both comma-separated values (CSV) and [JSON][json].  The CSV
files are suitable for loading into almost any program used for data analysis,
including Excel.  See the [Downloadable datasets](#downloadable-datasets)
section below for more information.

It's possible to **freeze** versions of an ISDB by making a read-only copy that
will never be modified.  These frozen versions are linked from the [main
page](../) of an ISDB website.  Freezing allows analyses to lock in a specific
version of the data for repeatability while still allowing corrections and new
data to flow into the latest in-flight version.

Custom reporting may be accomplished using SQL via R (with dplyr), Perl, or
a "business intelligence" tool such as [re:dash][redash] or [Tableau][].

This documentation also includes [a reference guide to the tables and
views](Tables.html) within an ISDB.

[reldb]: https://en.wikipedia.org/wiki/Relational_database
[sql]: https://en.wikipedia.org/wiki/SQL
[pg]: https://en.wikipedia.org/wiki/PostgreSQL
[redash]: http://redash.io/
[Tableau]: http://www.tableau.com
[json]: https://en.wikipedia.org/wiki/JSON

# Data usage guidelines

The most commonly used data stored in an ISDB is explained below.  Please be
sure to read these guidelines before embarking on an analysis or preparing a
data source for submission.  If anything isn't covered, please ask and we'll be
happy to answer your questions!

## Landmarks are usually chromosomes (`chr…`), but not always

The _landmark_ is the [NCBI RefSeq][refseq] sequence in which the reported
integration site is located.  Locations can only be compared within the same
landmark.

In almost all cases the landmark is a chromosome, and for convenience the ISDB
refers to chromosomes as chr1–20, chrX, and chrY rather than use their [RefSeq
accession][accession].

In very rare cases, the best landmark for an integration site is an unplaced
genomic region, an unlocalized genomic region, or some other non-chromosomal
scaffold.  (Refer to the [genome assembly glossary][glossary] for more
information on those terms.)  A [RefSeq accession][accession] is used as the
landmark in those cases, and the locations for such integration sites cannot be
compared to a chromosome.

The word "landmark" itself is the standard term widely used in the genomic data
community.

[refseq]: http://www.ncbi.nlm.nih.gov/refseq/about/
[glossary]: http://www.ncbi.nlm.nih.gov/projects/genome/assembly/grc/info/definitions.shtml
[accession]: http://www.ncbi.nlm.nih.gov/books/NBK21091/table/ch18.T.refseq_accession_numbers_and_mole/

## Locations use the human genome assembly version GRCh38 (hg38) {#hg38}

All locations are provided in __GRCh38__ (hg38) coordinates and determined
without using patch scaffolds (fix or novel) from patch releases.  This
provides portability and longevity of integration sites and makes analysis
simpler.  Refer to the [genome assembly glossary][glossary] for more
information on patch scaffolds.

When a new major assembly is released, lifting over coordinates will be easier
without the use of patch scaffolds.  Note that patch *releases* of the GRCh38
assembly (such as GRCh38.p2) are fine, as long as patch *scaffolds* are not
consulted when mapping IS locations.

## Locations number interbase spaces, not bases themselves

The location of integration junctions are reported in [_zero-origin, interbase
coordinates_][interbase].  This means that a `location` reported by the
database identifies a location _between_ two nucleotides, rather than
identifying a nucleotide.  These interbase locations are numbered starting with
position 0, which is to the left/5ʹ of the first base.

The same holds for `sequence_junction`, which, if available, reports the
detected location of the provirus/human junction in a reported `sequence`.

[interbase]: http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3383450/#__sec2

## Environment (_in vivo_ or _in vitro_) describes when the integration occurred

The `environment` field for each integration indicates the place where the
integration event occurred.  Natural integrations that occurred in the body are
described as _in vivo_, while integrations that occurred while in cell culture
are described as _in vitro_.  In many cases the _in vitro_ data will serve as a
control dataset that is the basis of comparison for the _in vivo_ data.

Note that the `environment` field does not describe differences between the
handling of cells once removed from the body.  _In vivo_ may describe
integrations in both subjects' cells which were directly sequenced and
subjects' cells first passaged through cell culture in the presence of
suppressive ART.  The presence of suppressive ART is critical as it ensures
that no (or minimal) new integrations occurred while in culture.

## Gene names are from NCBI

The gene names used in ISDB are the same as the primary gene symbols from
the [NCBI Gene](http://www.ncbi.nlm.nih.gov/gene/) database.  Genes often have
aliases, but ISDB does not use them.  The genes and their locations on the
human assembly are parsed from the GFF annotations provided by the Genome
Reference Consortium.

Note that gene names are not guaranteed by NCBI to be unique, although they
usually are in practice due to ISDB's filtered subset of NCBI Gene.  The
numeric `ncbi_gene_id` is guaranteed to be unique.

## A missing gene name means the IS is intergenic

If an integration site is intergenic (literally "between genes"), it will be
missing a gene name in the [Integration summary with annotated
genes](#integration-summary-with-annotated-genes) dataset and be lumped into
the row missing a gene name in the [Summary by Gene](#summary-by-gene) dataset.

Gene names that start with `LOC…` mean that someone, somewhere has evidence
(either experimental or computational) that a gene or gene-like region exists
at the location, but the gene itself hasn't been characterized.

Genes that produce non-coding RNA (ncRNA) are not specifically distinguished in
an ISDB and appear as normal gene names.  A list of human genes which produce
ncRNAs is obtainable from NCBI Gene by [searching for <tt>human[organism] and
NCRNA\*[symbol]</tt>][ncRNAs].

[ncRNAs]: http://www.ncbi.nlm.nih.gov/gene/?term=human%5Borgn%5D+and+NCRNA*%5Bsymbol%5D

## Sequencing evidence for integrations are always 5ʹ → 3ʹ, right to left

This practice makes analysis easier by normalizing all sequences.  Please
reverse complement your evidential sequences before submission if they're in
the 3ʹ → 5ʹ orientation.

# Downloadable datasets

Two summary datasets of the raw integration site observations are available for
download as CSV, Excel, and [JSON][json].

These datasets represent what seems like useful defaults, but we recognize that
there's no such thing as a default analysis or default person.  Custom reports
will give you exactly the data you want in the form that you want.

## Integration summary with annotated genes

The _integration gene summary_ report contains a row for each gene integration _event_ in
the database, along with that event's _clonal multiplicity_ as reported by the
source.  Note that integrations into **locations covered by multiple genes** (such
as two in opposite orientations) **will be reported once per gene**.

Individual integration site observations that share the same values for all
columns before `multiplicity` are collapsed and counted towards the final
`multiplicity`.

| column                     | type                 | example    |
|----------------------------+----------------------+------------|
| `environment`              | text                 | `in vivo`  |
| `subject`                  | text                 | `25011556_R1` |
| `ncbi_gene_id`             | integer              | `80208`    |
| `gene`                     | text                 | `SPG11`    |
| `landmark`                 | text                 | `chr5`     |
| `location`                 | non-negative integer | `44642671` |
| `orientation_in_landmark`  | orientation          | `F`        |
| `orientation_in_gene`      | orientation          | `R`        |
| `multiplicity`             | non-negative integer | `1`        |
| `source_names`             | text                 | `NCI-RID`  |
| `pubmed_ids`               | text                 | `25011556` |

### Fields {#common-fields}

#### `environment`

The environment in which the integration event took place.  Either _in vivo_ or
_in vitro_.  Refer to the [data usage guidelines](#data-usage-guidelines)
above.

#### `subject`

A label identifying the studied individual whose cells contained this integration event.

#### `ncbi_gene_id`

The ID number of the gene annotated at the integration site (if any) in the NCBI Gene database.

#### `gene`

The name of the gene annotated at the integration site (if any).

#### `landmark`

A chromosome label like `chr5`, `chr19`, or `chrX`, identifying the chromosome of the human genome the integration site maps to, or else a RefSeq accession number identifying a non-chromosome reference landmark.

#### `location`

The location of the integration splice junction, in 0-origin, interbase coordinates.

#### `multiplicity`

The _number of independent observations_ of this integration event within this source. Generally, we expect that if an event is observed more than once, the method used suggests clonal proliferation of a cell with integrated provirus at that site. We will endeavor _not_ to count technical replicates identifying the same integration site as an indication of multiplicity. For instance, if the ISLA reaction were performed in triplicate on cells from a single ICE culture, finding the same IS in all replicates, that data contributes a multiplicity of 1 rather than 3 due to the nature of the ICE protocol.

#### `source_names`

One or more labels identifying the source documenting the integration events in
this row.  Source names are separated by pipes `|`.

#### `pubmed_ids`

One or more numeric PubMed IDs identifying the paper which published or
analyzed the integration events in this row.  Multiple IDs are separated by
pipes `|`.

## Integration summary

The _integration summary_ report contains a row for each integration _event_ in
the database, along with that event's _clonal multiplicity_ as reported by the
source.  This report is _not_ annotated with gene information, and no data is
duplicated: each evidentiary record in the database contributes to the
multiplicity of one row in this report.

Individual integration site observations with the same values for
`environment`, `subject`, `landmark`, `location`, and `orientation_in_landmark`
are counted towards a row's `multiplicity`.

| column                    | type                 | example       |
|---------------------------+----------------------+---------------|
| `environment`             | text                 | `in vivo`     |
| `subject`                 | text                 | `25011556_R1` |
| `landmark`                | text                 | `chr5`        |
| `location`                | non-negative integer | `44642671`    |
| `orientation_in_landmark` | orientation          | `F`           |
| `multiplicity`            | non-negative integer | `1`           |
| `source_names`            | text                 | `NCI-RID`     |
| `pubmed_ids`              | text                 | `25011556`    |

### Fields

Field definitions and formats are the same as [fields in the integration gene
summary](#common-fields).

## Summary by Gene

The _summary by gene_ report counts integration sites appearing in annotated
genes across various subjects, sources, and locations.  Genes with both _in
vivo_ and _in vitro_ data are reported with two rows.

| column                 | type    | example   |
|------------------------+---------+-----------|
| `environment`          | text    | `in vivo` |
| `ncbi_gene_id`         | integer | `80208`   |
| `gene`                 | text    | `SPG11`   |
| `subjects`             | integer | `12`      |
| `unique_sites`         | integer | `14`      |
| `proliferating_sites`  | integer | `2`       |
| `total_in_gene`        | integer | `29`      |

### Fields

#### `environment`

The environment in which the integration event took place.  Either _in vivo_ or
_in vitro_.  Refer to the [data usage guidelines](#data-usage-guidelines)
above.

#### `ncbi_gene_id`, `gene`

The annotated gene for which integrations are being summarized.

#### `subjects`

The number of distinct subjects with viral integrations anywhere in this gene.

#### `unique_sites`

The number of distinct nucleotide positions within this gene where virus has been found to integrate. Multiplicity is ignored.

#### `proliferating_sites`

The number of distinct sites with a multiplicity >= 2.  Integrations observed
more than once are assumed to be due to clonal cell proliferation.

Currently this doesn't separate identical sites between subjects, although such
instances are extremely rare.

#### `total_in_gene`

The _total number of independent observations_ of integrations into this gene. This number is equal to the sum of `multiplicity` from each row of `integration_gene_summary` annotated with this `gene`, so it should _exclude_ technical replicates.
