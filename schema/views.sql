BEGIN;

DROP VIEW IF EXISTS summary_by_gene;
DROP VIEW IF EXISTS integration_summary;
DROP VIEW IF EXISTS integration_genes;

CREATE VIEW integration_genes AS
    SELECT integration.*,
           ncbi_gene_id                                     AS ncbi_gene_id,
           ncbi_gene.name                                   AS gene,
           CASE orientation_in_landmark || gene_orientation
               WHEN 'FF' THEN 'F'
               WHEN 'FR' THEN 'R'
               WHEN 'RR' THEN 'F'
               WHEN 'RF' THEN 'R'
           END                                              AS orientation_in_gene
      FROM integration
      LEFT JOIN ncbi_gene_location
             AS geneloc
             ON (    integration.landmark = geneloc.landmark
                 AND integration.location BETWEEN geneloc.gene_start AND geneloc.gene_end)
      LEFT JOIN ncbi_gene USING (ncbi_gene_id)
;

CREATE VIEW integration_summary AS
    SELECT source_name                                      AS source_name,
           environment                                      AS environment,
           sample->>'subject'                               AS subject,
           ncbi_gene_id                                     AS ncbi_gene_id,
           gene                                             AS gene,
           landmark                                         AS landmark,
           location                                         AS location,
           orientation_in_landmark                          AS orientation_in_landmark,
           orientation_in_gene                              AS orientation_in_gene,
           COUNT(1)                                         AS multiplicity
      FROM integration_genes
     GROUP BY source_name, environment, subject, ncbi_gene_id, gene, landmark, location, orientation_in_landmark, orientation_in_gene
;

CREATE VIEW summary_by_gene AS
    SELECT ncbi_gene_id,
           gene                                     AS gene,
           COUNT(DISTINCT subject)                  AS subjects,
           COUNT(DISTINCT (landmark, location))     AS unique_sites,
           SUM(multiplicity)                        AS total_in_gene,
           STRING_AGG(DISTINCT environment, '/' ORDER BY environment)
                                                    AS environments
      FROM integration_summary
     GROUP BY ncbi_gene_id, gene
;

COMMIT;
