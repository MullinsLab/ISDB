% Using the per-gene GFF exports

A gene-specific annotation file is produced for every gene which overlaps with
an integration site in the database.  The file format is [GFF3][] ("generic
feature format", version 3), a plain-text, tabular format for keeping sequence
annotations.

You can use these files to visually annotate a gene sequence with
integration sites from the database, using software such as [Geneious][].

The files use positions relative to the gene start, but expect the sequence
they annotate to be _in the direction of the chromosome_.  This means the GFF
files pair nicely with partial chromosome sequences as downloaded directly from
[GenBank][].

For example, the [BACH2 gene][] is on [chromosome 6 from base 89,926,528 to
90,296,912][BACH2 genbank].  Downloading a FASTA or GenBank file at the link
will produce a file suitable for annotating with the matching GFF file.

The [NCBI Gene][] data source within [Geneious][] also downloads suitable
sequence documents.

[GFF3]: https://github.com/The-Sequence-Ontology/Specifications/blob/master/gff3.md
[GenBank]: https://www.ncbi.nlm.nih.gov/nuccore/
[BACH2 gene]: http://www.ncbi.nlm.nih.gov/gene/60468
[BACH2 genbank]: https://www.ncbi.nlm.nih.gov/nuccore/NC_000006.12?from=89926528&to=90296912&report=genbank
[NCBI Gene]: https://www.ncbi.nlm.nih.gov/gene
[Geneious]: https://geneious.com

# Fields

Several fields are provided for each annotation.  Below is a a brief
description of the fields as used by our GFF3 files.

Field         Note
------------  ----
`seq_id`      Formatted as "gene name - gene id"
`source`      The name of the data source for the integration site
`type`        Always [`proviral_location`][type], a [Sequence Ontology] term
`start`       The integration site in gene-relative but chromosome-oriented coordinates
`stop`        Always equal to `start`, as required by the GFF3 specification for zero-length features
`score`       The multiplicity of the integration site
`strand`      Orientation of the virus relative to the *chromosome*
`phase`       Unused
`attributes`  `Name` is the subject, or if there's no subject, the integration environment.
              `ID` is a meaningless number unique to the file.


[type]: http://www.sequenceontology.org/browser/current_release/term/SO:0000751
[Sequence Ontology]: http://www.sequenceontology.org
