BEGIN;

-- Configuring authentication for these users is left as an exercise for the
-- reader: http://www.postgresql.org/docs/9.4/static/client-authentication.html
CREATE USER isdb_admin WITH CREATEDB;
CREATE USER isdb;
CREATE USER isdb_r;

COMMIT;
