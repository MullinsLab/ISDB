---
title: Database roles
topic: About data curation
order: 2.1
...

ISDB uses a few database users, or _roles_, to provide different levels of
access to the database.  PostgreSQL roles are separate from your computer's
users.  However, the user you're logged into your computer as will be the role
name used to connect to PostgreSQL unless you specify otherwise.

There are no hard requirements on database role names and access levels if you
have your own desired setup, but our documentation assumes you're using the
standard set of roles as described here and created by our `create-database`
tool.

Configuring authentication (e.g. passwords, client hostname rules, role to
database maps) for your database roles is beyond the scope of this document.
You can start learning more by reading about PostgreSQL's [client
authentication documentation][pgauth].

[pgauth]: http://www.postgresql.org/docs/current/static/client-authentication.html


# Access levels

Four conceptual access levels are used:

## Superuser

This is the PostgreSQL administrative user which can do __anything__ to __any__
database.  It is often named `postgres`, except on macOS when using
Postgres.app where it's your own username.  This role was created when you
installed PostgreSQL.

It is necessary to have superuser access to your Pg server in order to create
the ISDB-specific roles and initial database using the `create-database`
program.

## Owner

This user is the administrator for your ISDB and all tables, views, etc. inside
of it.  It has permission to see, modify, and delete data as well as create new
tables and upgrade the schema.

The standard name is `isdb_admin`, as created by the `create-database` program.

## Read/write

This user has permission to see, modify, and delete data in your ISDB but not
create new tables or otherwise change the schema.

The standard name is `isdb_rw`, as created by the `create-database` program.

## Read-only

This user has permission to see data in your ISDB but not make any changes.

The standard name is `isdb_ro`, as created by the `create-database` program.


# Granting access

PostgreSQL roles act like both users and groups at the same time.  You connect
to a database using a single role name, but roles may also be members of other
roles in order to inherit privileges.

The recommended way of granting access to your ISDB is by adding new or
existing PostgreSQL "user" roles to the standard ISDB "group" roles described
above.  Of course, you can set this up however makes sense for you, and it's
quite possible to connect directly using the ISDB roles above.
