---
title: Getting started
topic: About data curation
order: -1
...

This guide is intended to help you get started using ISDB and familiarize you
with its major components.  It assumes you are comfortable using the command
line, installing software on your system, and troubleshooting errors that arise
when installing and configuring software.  If you need help, we suggest
contacting a local expert familiar with your computing systems or [opening an
issue with us][].

[opening an issue]: https://github.com/MullinsLab/ISDB/issues/new?labels=question&title=Help+getting+started


# Overview

1. Install ISDB and create a new, empty database
2. Load example data sources into your database
3. Generate an example website and open it in your browser
4. Next steps


# Installation

ISDB is known to work on macOS and Linux (Ubuntu, Debian, Red Hat, CentOS) and
will likely work on any Unix-like operating system.  On Windows 10, you can
probably use ISDB via the [Windows Subsystem for Linux][], although we haven't
tried it out ourselves. (If you do, please let us know how it goes.)

Please follow the steps in the [installation guide](Install.md) and then come
back here to continue.

[Windows Subsystem for Linux]: https://docs.microsoft.com/en-us/windows/wsl/about


# Load example data sources

Distributed with ISDB is some of the source data used to populate
[HIRIS](https://mullinslab.microbiol.washington.edu/hiris/). Even if you don't
plan on using this data in your ISDB installation, we suggest loading these
sources to make sure the ISDB tools and the database you just set up are
working correctly.  The example sources are found in the `sources` directory of
your `isdb` directory:

    sources/
    ├── NCI-RID/
    ├── SherrillMix-2013/
    ├── Sunshine-2016-JVI/
    ├── Wagner-2014-Science/
    └── Wang-2007/

You can load all of those by running:

    ./bin/load-source sources/NCI-RID
    ./bin/load-source sources/SherrillMix-2013
    ./bin/load-source sources/Sunshine-2016-JVI
    ./bin/load-source sources/Wagner-2014-Science
    ./bin/load-source sources/Wang-2007

You should see output that looks like the following:

    Creating source NCI-RID... OK
    Loading integration sites...
    1000 lines processed in 0.967 seconds (1034 lines/s)
    2000 lines processed in 1.927 seconds (1038 lines/s)
    2733 lines processed in 2.639 seconds (1035 lines/s)
    2732 observations inserted
    OK

for each data source.  The data should now be in your database:

    $ psql isdb
    isdb=# select environment, count(*) from integration group by environment;
     environment │ count
    ─────────────┼───────
     in vitro    │ 57069
     in vivo     │  3260
    (2 rows)


# Generate a website

The data from the example sources is now in your database but is only
accessible by writing SQL queries for the database to run.  ISDB comes with
tools to generate a website containing summary information about your database,
downloads of exported data files in various formats, and other useful
information.  This website is the "face" of your database.  Generate it by
running:

    ./bin/generate-website ../isdb-example-website/

It will take a few minutes to export the data and build the website.  When it's
done, the directory `isdb-example-website` will exist alongside your `isdb`
directory and contain a plethora of files.  Open up the `index.html` file in
your web browser to view your website. On macOS, you can run:

    open ../isdb-example-website/index.html

On many Linux desktops, you can run:

    xdg-open ../isdb-example-website/index.html

Note that the generated website is _static_, which means it won't change when
your database changes unless you re-run the `generate-website` command above.
However, this allows you to easily copy the website directory to any webserver
or file share for sharing more widely.  You can even zip up the directory and
email it to someone for them to look at.

ISDB also includes tools for helping automatically keep your website up to date
and tailoring it to your needs.  You can read more about suggested practices
for website generation in our ["Generating the website" workflow
documentation](Workflows.md#generating-the-website).


# Next steps

At this point you probably want to start making the database your own by
working with your own data.  To start with a fresh database, delete the example
database you just created and re-create an empty one from scratch by running:

    dropdb isdb
    ./bin/create-database

Then, learn how to [create your own data sources](Sources.md) for loading and
[tailor the website for your needs](Website.md).
