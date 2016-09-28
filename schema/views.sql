BEGIN;

DROP VIEW IF EXISTS summary_by_gene;
DROP VIEW IF EXISTS integration_gene_summary;
DROP VIEW IF EXISTS integration_summary;
DROP VIEW IF EXISTS integration_genes;
DROP VIEW IF EXISTS sample_fields_metadata;

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
    SELECT environment                                      AS environment,
           sample->>'subject'                               AS subject,
           landmark                                         AS landmark,
           location                                         AS location,
           orientation_in_landmark                          AS orientation_in_landmark,
           COUNT(1)                                         AS multiplicity,
           ARRAY_AGG(DISTINCT source_name ORDER BY source_name)
                                                            AS source_names,
           ARRAY_AGG(DISTINCT (sample->>'pubmed_id')::int ORDER BY (sample->>'pubmed_id')::int)
               FILTER (WHERE (sample->>'pubmed_id') IS NOT NULL)
                                                            AS pubmed_ids
      FROM integration
  GROUP BY environment, subject, landmark, location, orientation_in_landmark
;

CREATE VIEW integration_gene_summary AS
    SELECT environment                                      AS environment,
           sample->>'subject'                               AS subject,
           ncbi_gene_id                                     AS ncbi_gene_id,
           gene                                             AS gene,
           landmark                                         AS landmark,
           location                                         AS location,
           orientation_in_landmark                          AS orientation_in_landmark,
           orientation_in_gene                              AS orientation_in_gene,
           COUNT(1)                                         AS multiplicity,
           ARRAY_AGG(DISTINCT source_name ORDER BY source_name)
                                                            AS source_names,
           ARRAY_AGG(DISTINCT (sample->>'pubmed_id')::int ORDER BY (sample->>'pubmed_id')::int)
               FILTER (WHERE (sample->>'pubmed_id') IS NOT NULL)
                                                            AS pubmed_ids
      FROM integration_genes
     GROUP BY environment, subject, ncbi_gene_id, gene, landmark, location, orientation_in_landmark, orientation_in_gene
;

CREATE VIEW summary_by_gene AS
    SELECT environment,
           ncbi_gene_id,
           gene                                     AS gene,
           CASE environment
             WHEN 'in vivo'  THEN COUNT(DISTINCT subject)
             WHEN 'in vitro' THEN null
           END                                      AS subjects,
           COUNT(DISTINCT (landmark, location))     AS unique_sites,
           COUNT(DISTINCT (landmark, location))
                 FILTER (WHERE multiplicity >= 2)   AS proliferating_sites,
           SUM(multiplicity)                        AS total_in_gene
      FROM integration_gene_summary
     GROUP BY environment, ncbi_gene_id, gene
;

CREATE VIEW sample_fields_metadata AS
    SELECT field,
           count(1),
           count(DISTINCT sample->>field)        as values,
           array_agg(DISTINCT source_name
                     ORDER BY source_name)       as sources,
           array_agg(DISTINCT environment::text
                     ORDER BY environment::text) as environments
      FROM (SELECT DISTINCT jsonb_object_keys(sample) AS field FROM integration)
        AS sample_fields
      JOIN integration ON (sample ? field AND sample->>field != '')
     GROUP BY field
     ORDER BY count(DISTINCT source_name) DESC, count DESC
;

COMMIT;
