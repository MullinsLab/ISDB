BEGIN;

CREATE DOMAIN integration_environment AS text CHECK (
    VALUE IN ('in vivo', 'in vitro')
);

CREATE DOMAIN ltr_end AS text CHECK (
    VALUE IN ('5p', '3p')
);

CREATE DOMAIN landmark AS text CHECK (
    VALUE IN (
         'chr1',  'chr2',  'chr3',  'chr4',  'chr5',  'chr6',  'chr7',  'chr8',  'chr9', 'chr10',
        'chr11', 'chr12', 'chr13', 'chr14', 'chr15', 'chr16', 'chr17', 'chr18', 'chr19', 'chr20',
        'chr21', 'chr22',  'chrX',  'chrY', 'chrMT'
    )
    OR
    -- Looks like a RefSeq accession for a complete region¹, but not one of the
    -- chromosomal accessions.  By observation, chromosomal accessions are
    -- NC_000001–NC_000024 for 1–22, X, & Y and NC_012920 for mitochondrial (MT).
    -- 
    -- ¹ http://www.ncbi.nlm.nih.gov/books/NBK21091/table/ch18.T.refseq_accession_numbers_and_mole/
    (    VALUE  ~ E'^N[CTW]_\\d{6,}\\.\\d+$'
     AND VALUE !~ E'^NC_(0000(0[1-9]|1[0-9]|2[0-4])|012920)\\.')
);

CREATE DOMAIN orientation AS text CHECK (
    VALUE IN ('F', 'R')
);

CREATE DOMAIN gene_type AS text CHECK (
    -- Values from the ASN.1 definition of an NCBI Gene document:
    --    https://www.ncbi.nlm.nih.gov/IEB/ToolBox/CPP_DOC/lxr/source/src/objects/entrezgene/entrezgene.asn
    --
    -- We'll use NULL for "unknown".
    --
    VALUE IN (
        'protein-coding',
        'pseudo',
        'rRNA',
        'tRNA',
        'ncRNA',
        'scRNA',
        'snRNA',
        'snoRNA',
        'miscRNA',
        'transposon',
        'biological-region',
        'other'
    )
);

CREATE TABLE ncbi_gene (
    ncbi_gene_id    integer NOT NULL PRIMARY KEY,
    name            text    NOT NULL,
    type            gene_type
);
CREATE INDEX ncbi_gene_name_upper_idx ON ncbi_gene(UPPER(name));
CREATE INDEX ncbi_gene_type_idx       ON ncbi_gene(type);

CREATE TABLE ncbi_gene_location (
    ncbi_gene_id        integer             NOT NULL REFERENCES ncbi_gene(ncbi_gene_id),
    landmark            landmark            NOT NULL,
    gene_start          integer             NOT NULL,
    gene_end            integer             NOT NULL,
    gene_orientation    orientation         NOT NULL,
    PRIMARY KEY (ncbi_gene_id, landmark, gene_start)
);
CREATE INDEX ncbi_gene_location_idx ON ncbi_gene_location(landmark, gene_start, gene_end);

-- Source document example fields
--  • pubmed_id
--  • lab

CREATE TABLE source (
    source_name     varchar(255) NOT NULL PRIMARY KEY,
    document        jsonb,
    revision        jsonb
);

CREATE INDEX source_document ON source USING gin (document);
CREATE INDEX source_revision ON source USING gin (revision);

-- Sample document example fields
--  • subject
--  • sample_name
--  • rxn
--  • method

CREATE TABLE integration (
    source_name                         varchar(255) NOT NULL,
    environment                         integration_environment NOT NULL,
    sample                              jsonb,
    ltr                                 ltr_end,
    landmark                            landmark,
    location                            integer CHECK (location >= 0 OR location IS NULL),
    orientation_in_landmark             orientation,
    sequence                            text,
    sequence_junction                   integer CHECK (sequence_junction >= 0 OR sequence_junction IS NULL),
    note                                text,
    info                                jsonb,

    FOREIGN KEY (source_name)  REFERENCES source (source_name)
);

CREATE INDEX integration_source_name_idx          ON integration(source_name);
CREATE INDEX integration_environment_idx          ON integration(environment);
CREATE INDEX integration_sample_idx               ON integration USING gin (sample);
CREATE INDEX integration_landmark_location_idx    ON integration(landmark, location);
CREATE INDEX integration_ltr_idx                  ON integration(ltr);

COMMIT;
