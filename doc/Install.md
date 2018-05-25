---
title: Installation guide
topic: About data curation
order: 0
...

This installation guide assumes the reader is comfortable using the command
line, installing software on their system, and troubleshooting errors that
arise when installing and configuring software. If you need help, we suggest
contacting a local expert familiar with your computing systems.

# Overview

1. Install software prerequisites for your operating system
2. Download ISDB source code
3. Install ISDB's direct dependencies
4. Create your database and test your connection
5. Next steps

# Prerequisites

[Perl](https://www.perl.org) 5.14 or later, standard Unix tools including
`make`, and [libcurl](https://curl.haxx.se) are all required to run the ISDB
tools.

ISDB is designed to use [PostgreSQL](https://www.postgresql.org) as the
database server. You must either have "superuser" access to a PostgreSQL
server, or access to the owner role of a database set up for your use.

## Installing prerequisites on Mac OS X/macOS

1. Install Apple's command line developer tools with:

       xcode-select --install

2. Download and install [Postgres.app](http://postgresapp.com)

3. Configure your shell to make the PostgreSQL command line tools available:

       sudo mkdir -p /etc/paths.d
       sudo tee /etc/paths.d/postgresapp <<</Applications/Postgres.app/Contents/Versions/latest/bin
       export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

MacOS versions starting with 10.9 (Mavericks), released in 2013, include a
sufficiently new version of Perl to run all the ISDB tools. libcurl is included
with macOS as well.

## Installing prerequisites on Debian or Ubuntu

1. Install packaged dependencies:

       apt-get install build-essential git pkg-config libcurl4-gnutls-dev

2. Set up the PostgreSQL APT repository appropriate for your system
   [Debian](https://www.postgresql.org/download/linux/debian/),
   [Ubuntu](https://www.postgresql.org/download/linux/ubuntu/) following their
   instructions

3. Install libpq and PostgreSQL 9.4 or later:

       apt-get install libpq-dev postgresql-9.4

The oldest currently supported Ubuntu release, Ubuntu 12.04.5 LTS, is known to
work with ISDB tools.

## Installing prerequisites on Red Hat or CentOS

These instructions should also work on Fedora and other RHEL variants, although
they've only been tested on CentOS 7.

1. Install packaged dependencies:

       yum install @development libcurl-devel perl-core

2. Set up the [PostgreSQL yum repository](https://www.postgresql.org/download/linux/redhat/)
   for at least Pg 9.4 or newer following their instructions

3. Install PostgreSQL 9.4 or later:

       yum install postgresql9.4{,-docs,-devel}


# Download ISDB

ISDB is distributed as source code and data directly from our [version control
repository][].  We aim to keep the branch ("version") named `master` up-to-date
and suitable for use at all times.

To download a copy of ISDB, use [git][] (which was installed if necessary in
the previous steps):

    git clone https://github.com/MullinsLab/ISDB.git isdb

This will show its progress and should generally take less than a minute.  When
it's done, you'll have a new directory called `isdb`.  Move into it on the
command line by running:

    cd isdb


[version control repository]: https://github.com/MullinsLab/ISDB
[git]: https://en.wikipedia.org/wiki/Git_(software)


# Install ISDB's direct dependencies

The tools for populating the ISDB have dependencies that do not need to be
installed system-wide. Once all the prerequisites are met, run:

    make deps

inside your local `isdb` directory to download these dependencies. The
following components will be downloaded and installed within the `isdb`
directory:

* The `cpanm` tool for managing Perl libraries
* Required Perl libraries from [CPAN](https://metacpan.org)
* The UCSC Genome Browser's `liftOver` tool
* The `liftOver` chain file for mapping hg19 to hg38 coordinates
* Gene annotation and chromosome metadata from the [NCBI](https://www.ncbi.nlm.nih.gov)
* [Pandoc](http://pandoc.org) for generating documentation web pages

# Create the database

The ISDB maintenance utilities are set up to run from inside the directory
containing the source code.  Once dependencies are installed, all the tools
under `bin/` should be functional.

You can use the `bin/create-database` tool to create a new database called
`isdb` on your local PostgreSQL server.  It must be run as a database
superuser since it creates users and a database.  This tool connects to
PostgreSQL based on environment variables; see the [database connection
documentation](Database-connection.md) for details.

If you're using macOS and Postgres.app, then your macOS user is already a
superuser so you can run:

    ./bin/create-database

If you're on Linux or a vanilla PostgreSQL install, you'll need to run the
tool as the `postgres` system user:

    sudo -u postgres ./bin/create-database

After that, add your own Linux user as an ISDB administrator so you'll be able
to run ISDB tools without using `sudo -u postgres` again:

    sudo -u postgres createuser --role=isdb_admin $USER

You should now be able to connect to the `isdb` database and confirm that the
basics have been loaded. For example:

```
$ psql isdb
isdb =# select count(*) from ncbi_gene;
 count
-------
 51141
(1 row)
isdb =# select count(*) from integration;
 count
-------
     0
(1 row)
```

# Next steps

ISDB tools are distributed with some of the source data used to populate
[HIRIS](https://mullinslab.microbiol.washington.edu/hiris/). Even if you don't
plan on using this data in your ISDB installation, we suggest loading these
sources to make sure the ISDB tools and the database you just set up are
working correctly. You can use the [`load-source` tool](Workflows.md) to load
the example sources (found in the `sources` directory of this distribution).

For step-by-step instructions, pick up the [getting started
guide](Getting-started.md) at the "Load example data sources" section.
