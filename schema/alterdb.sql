-- This file should be run as an existing superuser.
BEGIN;

-- The default public schema from template0 is owned by the default Pg
-- superuser and we want to own it so our owner has full control after this.
ALTER SCHEMA public OWNER TO :owner;

-- This works iff we're the superuser or the owner of the public schema.
-- Otherwise, it quietly does nothing!
REVOKE CREATE ON SCHEMA public FROM PUBLIC;

COMMIT;
