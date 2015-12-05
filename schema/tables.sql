BEGIN;

CREATE DOMAIN ltr_end AS text CHECK (
    VALUE IN ('5p', '3p')
);

CREATE DOMAIN human_chromosome AS text CHECK (
    VALUE IN (
         '1',  '2',  '3',  '4',  '5',  '6',  '7',  '8',  '9', '10',
        '11', '12', '13', '14', '15', '16', '17', '18', '19', '20',
        '21', '22',  'X',  'Y'
    )
);

CREATE DOMAIN orientation AS text CHECK (
    VALUE IN ('F', 'R')
);

CREATE TABLE ncbi_gene (
    ncbi_gene_id    integer NOT NULL PRIMARY KEY,
    name            text    NOT NULL
);
CREATE INDEX ncbi_gene_name_upper_idx ON ncbi_gene(UPPER(name));

CREATE TABLE ncbi_gene_alias (
    ncbi_gene_id    integer NOT NULL REFERENCES ncbi_gene(ncbi_gene_id),
    name            text    NOT NULL,
    PRIMARY KEY (ncbi_gene_id, name)
);
CREATE INDEX ncbi_gene_alias_name_upper_idx ON ncbi_gene_alias(UPPER(name));

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
    refseq_accession                    varchar(255),

    -- XXX TODO: reference?  landmark?  chrX instead of just 'X'?  no constraint on
    -- value, to allow landmark names other than chromosomes?
    chromosome                          human_chromosome,
    location                            integer CHECK (location >= 0 OR location IS NULL),
    orientation_in_reference            orientation,        -- XXX TODO: landmark?
    orientation_in_gene                 orientation,
    ncbi_gene_id                        integer,
    sequence                            text,
    sequence_junction                   integer CHECK (sequence_junction >= 0 OR sequence_junction IS NULL),
    note                                text,
    info                                jsonb,

    FOREIGN KEY (source_name)  REFERENCES source (source_name),
    FOREIGN KEY (ncbi_gene_id) REFERENCES ncbi_gene (ncbi_gene_id)
);

CREATE INDEX integration_source_name_idx          ON integration(source_name);
CREATE INDEX integration_sample_idx               ON integration USING gin (sample);
CREATE INDEX integration_chromosome_location_idx  ON integration(chromosome, location);
CREATE INDEX integration_ltr_idx                  ON integration(ltr);
CREATE INDEX integration_ncbi_gene_id_idx         ON integration(ncbi_gene_id);

--- XXX TODO: ACL

COMMIT;
