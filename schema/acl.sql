BEGIN;

GRANT SELECT
   ON ALL TABLES IN SCHEMA public
   TO isdb_r;

GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE
   ON ALL TABLES IN SCHEMA public
   TO isdb;

COMMIT;