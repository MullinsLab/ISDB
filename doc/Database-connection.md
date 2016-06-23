% Database connection

The ISDB expects to connect to a [PostgreSQL][] (Pg) database for storing and
retrieving data.  The Pg database software may be running on the local computer
or on a remote server.

All of the ISDB tools are designed to use connection details controlled by
[standard PostgreSQL environment variables][envvars] and configuration files.
This document describes how to specify those connection details and the
assumptions the ISDB tools make.

# Specifying connection details

The database name should be specified by `PGDATABASE`.  The ISDB tools default
the database name to `isdb` if unspecified.  You may only have occasion to
change this if accessing [frozen versions][] of the ISDB.

The location of the Pg server should be specified by `PGHOST`.  If you're
working with a Pg database on the same machine as the ISDB tools, you can
usually leave `PGHOST` unset.

The Pg user should be specified by setting `PGUSER`.  If left unset, Pg uses
the username of the person running the command.

Passwords should be specified in a [password file][pgpass] rather than
interactively or on the command line.

You may also use a [service file][pgservice] definition containing host and
user by setting `PGSERVICE`.  The ISDB tools forcibly default the database name
to `isdb` if `PGDATABASE` isn't set, however, so any database named in the
service definition will effectively be ignored.  (This may be remedied in the
future, as service definitions are handy!)

# Example

Below is an example of how to specify database connection details on the
command line when running an ISDB tool:

    env PGUSER=isdb_admin PGHOST=ireland ~/isdb/bin/load-source Wagner-2014-Science

This tells the tool to connect to a computer named `ireland` as the user named
`isdb_admin`.  The database name is unspecified, so it defaults to `isdb`.

The `load-source` tool is responsible for all aspects of taking an [ISDB data
source][sources] and loading it into the database.  However, the particulars of
specifying database connection details are the same across all ISDB tools.

[PostgreSQL]: https://postgresql.org
[envvars]: https://www.postgresql.org/docs/current/static/libpq-envars.html
[pgpass]: https://www.postgresql.org/docs/current/static/libpq-pgpass.html
[pgservice]: https://www.postgresql.org/docs/current/static/libpq-pgservice.html
[frozen versions]: Freezing.html
[sources]: Sources.html
