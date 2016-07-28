% Freezing versions of the ISDB

From time to time we freeze versions of the ISDB by making a read-only copy
that will never be modified.  These frozen versions are linked from the main
page of the ISDB.  Freezing allows analyses to lock in a specific version of
the data for repeatability while still allowing corrections and new data to
flow into the latest in-flight version.

Frozen versions of the ISDB are a combination of two things:

1. A copy of the database to which only read-only access is permitted
2. A specially regenerated copy of the website from the database copy

This provides a permanent URL for the frozen version with the various data
exports as well as a full copy of the database from which custom reports can
continue to be made.

# Freezing a new version

## Copy the database

The recommended form of the copied database name is `isdb_` followed by the
name you'll use for the frozen version.  Dates are recommended, meaning that
the database name would look like: `isdb_2016-03-25`.

It's highly recommended that only read-only access is permitted to the copied
database.  By Mullins Lab convention, we use an `isdb_r` role in Postgres.

To create the copy, run the following as a Postgres superuser on your database
server:

    createdb -T isdb -O isdb_admin isdb_2016-03-25

(Replace `-T isdb` with the name of your live database if it's not `isdb`.)

## Generate a frozen website

With the database copy you can now generate a frozen version of the website.

First fetch a clone of the ISDB website's git repository and make sure it's
up-to-date with the remote.  In the example below, that's at the path
`../isdb-web-internal/`.

Now run `generate-website` using an invocation similar to the following:

    env PGUSER=isdb_r PGHOST=ireland PGDATABASE=isdb_2016-03-25 \
        ./bin/generate-website \
            --compare \
            --freeze-as 2016-03-25 \
            ../isdb-web-internal/

Note that you should connect as the read-only user to the frozen copy of the
database so the Postgres connection details on the frozen website are correct.
(This, along with `--compare`, also ensures that re-running the command will be
idempotent.)

Make sure to commit and push your changes to the web repository.

The new frozen version will be picked up by the daily cronjob that regenerates
the live website.  You can also run the cronjob manually to pick it up
immediately.
