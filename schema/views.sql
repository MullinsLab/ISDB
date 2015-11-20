BEGIN;

DROP VIEW IF EXISTS summary_by_gene;
DROP VIEW IF EXISTS integration_summary;

CREATE VIEW integration_summary AS
    SELECT source_name                                      AS source_name,
           sample->>'subject'                               AS subject,
           ncbi_gene.name                                   AS gene,
           COUNT(1) OVER gene                               AS total_in_gene,

           COALESCE('chr' || chromosome, refseq_accession)  AS landmark,
           location                                         AS location,
           COUNT(1) OVER location                           AS total_at_location,

           orientation_in_reference                         AS orientation_in_reference,
           orientation_in_gene                              AS orientation_in_gene,
           COUNT(1)                                         AS multiplicity
      FROM integration
      LEFT JOIN ncbi_gene USING (ncbi_gene_id)
     GROUP BY source_name, subject, gene, landmark, location, orientation_in_reference, orientation_in_gene
    WINDOW gene     AS (PARTITION BY source_name, sample->>'subject', ncbi_gene.name),
           location AS (PARTITION BY source_name, sample->>'subject', ncbi_gene.name,
                                     COALESCE('chr' || chromosome, refseq_accession),
                                     location)
;

CREATE VIEW summary_by_gene AS
    SELECT gene                                     AS gene,
           COUNT(DISTINCT subject)                  AS subjects,
           COUNT(DISTINCT (landmark, location))     AS unique_sites,
           SUM(multiplicity)                        AS total_in_gene
      FROM integration_summary
     GROUP BY gene
;

-- XXX TODO: ACL

COMMIT;
