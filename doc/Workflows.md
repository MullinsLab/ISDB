---
title: Workflows for database maintenance
topic: About data curation
order: 3
...


# Running ISDB tools

All the scripts in the `bin` directory of the ISDB distribution can be run from
the checkout and do not need to be installed. For example, both

```
user@host:~ $ cd path/to/isdb
user@host:isdb $ ./bin/generate-website
```

and

```
user@host:~ $ path/to/isdb/bin/generate-website
```

will work correctly.

All ISDB tools respect the database connection environment variables checked by
PostgreSQL; see the [Database connection](Database-connection.html)
documentation for details.

# Loading sources

An ISDB is loaded with data from multiple _sources_. Each source is contained
within its own directory holding all the necessary files for that source. Each
source requires a file called `transformed.csv`, which contains integration
data, and `metadata.json`, which provides some information about the source.
More information is available in the [Sources][] documentation.

A source can be loaded into the database using `load-source`.

```
user@host:~ $ ls
isdb
My-HIV-Integrations
user@host:~ $ cd isdb
user@host:~/isdb $ ./bin/load-source ../My-HIV-Integrations
```

The `load-source` script _completely reloads_ the integrations from the source
being loaded. Existing records from that source are removed from the database,
then records from the current version of the source are added.

# Removing a source

The `drop-source` script deletes all integration records from a given source
from the target database. It does not modify any of the files for the source
data.

```
user@host:~/isdb $ ./bin/drop-source ../path/to/source/metadata.json
```

# Generating the website

The `generate-website` script creates a static site describing the data in your
ISDB, along with exported tabular summaries of the data. The [HIRIS][] website
is generated using the ISDB tools.

```
user@host:~/isdb $ ./bin/generate-website output-directory
```

The required `output-directory` argument gives the path where the site will be
generated. We suggest using a different directory from your ISDB checkout and
maintaining it under its own version control. For example, on first run:

```
user@host:isdb $ ./bin/generate-website ../my-db-website
user@host:isdb $ cd ../my-db-website
user@host:my-db-website $ git init
user@host:my-db-website $ git commit -am "Record initial website state"
```

And then subsequently:

```
user@host:isdb $ ./bin/generate-website ../my-db-website
user@host:isdb $ cd ../my-db-website
user@host:my-db-website $ git commit -am "Record website updates"
```

The contents of the `my-db-website` directory can then be placed in the
document root of a web server. (Configuration of a web server is beyond the
scope of this document.)

Run `generate-website --help` to see a summary of other options.

# Exporting data files

The data files generated by `generate-website` can also be created without a
website using the `export` tool, such as for storing on a network drive.

```
user@host:~/isdb $ ./bin/export output-directory
```

The required `output-directory` argument gives the path where the exported
files will be saved. The files with names ending in `.metadata.json` generated
by this tool store information used by `export` and `generate-website` tools
and should be left in place in the output directory.

By default, the `export` tool outputs several data sets in several different
formats. Run `export --help` to see a summary of other options.

[HIRIS]: http://mullinslab.microbiol.washington.edu/hiris/
[Sources]: Sources.html