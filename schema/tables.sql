BEGIN;

CREATE DOMAIN ltr_end AS text CHECK (
    VALUE IN ('5p', '3p')
);

CREATE DOMAIN landmark AS text CHECK (
    VALUE IN (
         '1',  '2',  '3',  '4',  '5',  '6',  '7',  '8',  '9', '10',
        '11', '12', '13', '14', '15', '16', '17', '18', '19', '20',
        '21', '22',  'X',  'Y', 'MT'
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

CREATE TABLE ncbi_gene (
    ncbi_gene_id    integer NOT NULL PRIMARY KEY,
    name            text    NOT NULL
);
CREATE INDEX ncbi_gene_name_upper_idx ON ncbi_gene(UPPER(name));

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
    document        jsonb
);

CREATE INDEX source_document ON source USING gin (document);

-- Sample document example fields
--  • subject
--  • sample_name
--  • rxn
--  • method

CREATE TABLE integration (
    source_name                         varchar(255) NOT NULL,
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
CREATE INDEX integration_sample_idx               ON integration USING gin (sample);
CREATE INDEX integration_landmark_location_idx    ON integration(landmark, location);
CREATE INDEX integration_ltr_idx                  ON integration(ltr);

COMMIT;
