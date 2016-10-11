---
title: Data sources for an ISDB
topic: About data curation
order: 1
...

An ISDB is loaded with data from multiple _sources_.  Sources are independent
of each other and may represent a single publication's data, unpublished data,
data from multiple publications, or any other collection of integration data.
How you use sources is largely unconstrained, but they work well for loosely
organizing the data which goes into your ISDB.

Each source is contained within its own directory holding all the necessary
files for that source.  By convention, the name of the directory containing all
the source files matches the name of the source itself.

Generally a source directory contains a copy of the primary or analyzed data
(or a way to automatically download that data) along with code to transform the
data into integration site records suitable for loading into the ISDB.  We
encourage you to use version control, such as [Git][], to manage your sources.
We generally make each source its own git repository, although there are
exceptions such as the sources bundled with the ISDB software.

Here's an example of a source directory, which you may find in the _sources/_
directory of the ISDB git repository:

    Wagner-2014-Science/
    ├── 1256304WagnerTableS3-Revised.csv
    ├── 1256304WagnerTableS3-Revised.xlsx
    ├── Makefile
    ├── metadata.json
    ├── orphaned.bed
    ├── tocsv
    ├── transform
    ├── transform.recs
    ├── integrations-GRCh37.csv
    └── integrations.csv

The two required files for each source are _metadata.json_ and
_integrations.csv_.  The former is details about the source and the latter is
the data transformed into records suitable for loading into an ISDB.  Each is
discussed in more detail below.

The other files are the published data files and code to transform those data
files into _integrations.csv_.

[Git]: https://en.wikipedia.org/wiki/Git_(software)

# Metadata

Each source must have some basic metadata associated with it.  The metadata is
provided by a _metadata.json_ file which gets loaded into the `source` table's
`document` field.

Every metadata.json must have the keys _name_ and _uri_.  The _name_ is used as
the source's primary key and must be unique within your ISDB.  The _uri_ should
point to the upstream source of the data or provide a [`mailto:`][mailto] link
for starting correspondence.

If the source is published work, the metadata should also have a _pubmed_ key
containing the PubMed Identifier (PMID) and a _citation_ key with a
[BibTeX][]-style citation.

A complete example is below:

```json
{
    "name": "Wagner-2014-Science",
    "uri": "https://mullinslab.microbiol.washington.edu/publications/wagner_2014_science/",
    "pubmed": 25011556,
    "citation": {
        "_type":    "@article",
        "_citekey": "Wagner-2014-Science",
        "author":   "Wagner, Thor A. and McLaughlin, Sherry and Garg, Kavita and Cheung, Charles Y. K. and Larsen, Brendan B. and Styrchak, Sheila and Huang, Hannah C. and Edlefsen, Paul T. and Mullins, James I. and Frenkel, Lisa M.",
        "title":    "Proliferation of cells with HIV integrated into cancer genes contributes to persistent infection",
        "journal":  "Science",
        "volume":   345,
        "number":   6196,
        "pages":    "570-573",
        "year":     2014,
        "issn":     "0036-8075",
        "doi":      "10.1126/science.1256304",
        "URL":      "http://science.sciencemag.org/content/345/6196/570",
        "eprint":   "http://science.sciencemag.org/content/345/6196/570.full.pdf"
    }
}
```

[mailto]: https://en.wikipedia.org/wiki/Mailto
[BibTeX]: https://en.wikipedia.org/wiki/BibTeX

# Integration site data

The ISDB tools load integration site observations from a CSV file called
_integrations.csv_.  The CSV file should contain the column headers as the first
line.  Each subsequent line is inserted into the database as a row in the
`integration` table.

The `integration` table is the primary fact table in an ISDB.  Each row
records a single occurrence of a provirus detected at the given integration
site in the given sample by the given source data.  Sites which are detected
multiple independent times (i.e. not from PCR) in a given sample are
represented as multiple rows.  Technical replicates are excluded if they're
from single genome sequencing rather than bulk consensus sequencing.  These
constraints allow the multiplicity of an IS to be calculated on the fly rather
than stored in the database.  One upshot of this is that it allows data loads
to be independent of one another.

The following fields are supported:
    
* `source_name` — refers to the name in your source's _metadata.json_
* `environment`
* `sample`
* `landmark` and `location` — both must either have values or be empty
* `orientation_in_landmark` — `F` (forward) or `R` (reverse), relative to `landmark`
* `ltr` — value of `5p` or `3p`
* `sequence`
* `sequence_junction`, if `sequence` is provided
* `note`
* `info`

For more information on how these fields are used and what values they should
contain (paying particular attention to coordinate systems), please read the
["Data usage guidelines" in the Manual](Manual.html#data-usage-guidelines).

Two fields, _sample_ and _info_, are JSON documents which can have arbitrary
structure.  These structured documents are reconstructed from the flat CSV
records through special field naming using `/` and `/#` to nest into hashes and
arrays.  For example, to store the following JSON document in the _sample_
field:

```json
{
    "subject":   "25011556_B1",
    "pubmed_id": 25011556,
    "reactions": [
        "ABC123",
        "XYZ789"
    ]
}
```

you'd represent it in the CSV as:

```csv
…,sample/subject,sample/pubmed_id,sample/reactions/#0,sample/reactions/#1,…
…,25011556_B1,25011556,ABC123,XYZ789,…
```

See the _transform.recs_ files in the stock data sources for examples of our
_sample_ and _info_ document conventions.

# Reference version and coordinate liftover

As [described in the manual](Manual.html#hg38), ISDB tools handle genome
coordinates using the GRCh38/hg38 human genome reference. This means that when
loading your own integrations, if they were mapped to an earlier reference
release (such as GRCh37/hg19), chromosomal coordinates must be translated to
GRCh38 as a step in preparing your `integrations.csv` file. The best way of
doing this is to download the UCSC [`liftOver`][] tool and use it to translate
each coordinate in your data set.

[liftOver]: https://genome.ucsc.edu/cgi-bin/hgLiftOver
