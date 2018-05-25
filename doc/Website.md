---
title: Tailoring the website
topic: About data curation
order: 3.5
...

<p class="notice bg-info">
If you haven't read the [introduction to generating the website][intro] in the
[Workflows][] documentation, please do so first.  This document will make more
sense after you follow those steps.
</p>

The default static website generated from your database is a great starting
point.  It should be all you need to get starting sharing your integration site
data with your lab mates and collaborators.  As you look to share your data
more widely though, it can be useful to tailor the generated website to your
specific data and research interests.

This tailoring can range from changing the website name to adding a few
explanatory paragraphs to the front page to creating your own documentation
pages.  All changes start with providing your own configuration file that
tweaks the default settings.

[intro]: Workflows.md#generating-the-website
[Workflows]: Workflows.md


# A local config file

The default config file is named `config.yaml`.  It provides examples of the
options available and default values, but it shouldn't be edited directly.
Instead, you should create a new file `config_local.yaml` in the same
directory.[^configvar] Options in `config_local.yaml` override those in
`config.yaml`.

Start by creating `config_local.yaml` with this text:

```yaml
---
contact: your-email-address@example.com
```

Replace `your-email-address@example.com` with your own email address, of
course.  It will be used on your website to provide a contact address for
questions.

<p class="notice bg-info">
In this document, each example of editing your `config_local.yaml` builds upon
the previous examples, so changes from previous sections are retained.  You do
not have to include all options in the examples if you don't want to.
</p>


[^configvar]: If you'd like to save your config file somewhere else or give it
a different name, you can use the environment variable `ISDB_CONFIG` to specify
a specific file to load in addition to `config_local.yaml` and `config.yaml`.
We do this in the Mullins Lab so our config files can live in version control
alongside the website.


# Giving your database a name

To start, let's give your database a name and title a little more exciting than
the generic placeholders.  As an example, edit your `config_local.yaml` file to
read:

```yaml
---
contact: your-email-address@example.com
name: FelineIS
web:
  title: FIV Integration Sites
```

Now let's see the results!  Every time you make a configuration change you'll
need to regenerate the website.  This is because the website is static and
represents your database and configuration at a single point-in-time.  We'll
use the `generate-website` tool to update the website, but instead of updating
_everything_ while testing changes, we can ask it to skip refreshing the data
exports and cached metadata.  Assuming you're using the same directory from
[earlier][intro], run:

```sh
./bin/generate-website --skip-exports --skip-cached ../my-db-website/
```

The output should look similar to:

    Output to: ../my-db-website/
    Writing version metadata: latest
    Copying static assets
    Rendering templates
    Rendering web/data.tt
    Rendering web/index.tt
    Rendering web/sources.tt
    Rendering web/doc/Tables.tt
    Generating documentation
    Converting Database-connection.md
    Converting Freezing.md
    Converting GFF-per-gene-exports.md
    Converting Install.md
    Converting Manual.md
    Converting Roles.md
    Converting Sources.md
    Converting Website.md
    Converting Workflows.md
    Indexing documentation
    Rendering web/doc/index.tt

Now open up the static site in your browser.  You can either do that from the
command line:

```sh
open ../my-db-website/index.html        # macOS
xdg-open ../my-db-website/index.html    # Linux
```

or point your browser at a URL like the following:

    file:///path/to/my-db-website/index.html


# Custom HTML

There are several places in the standard pages where you can provide custom
HTML, or templates, to be included:

* `head` — Included inside the `<head>` tag of every page
* `blurb` — The main content in the homepage's left hand column
* `footer` — Included at the bottom of every page, above the "Built with ISDB" part

To use any of these named sections (`head`, `blurb`, and `footer`), edit your
`config_local.yaml` to point to a file containing your HTML.  For example, to
write your own blurb for the front page:

```yaml
---
contact: your-email-address@example.com
name: FelineIS
web:
  title: FIV Integration Sites
  template:
    blurb: custom/html/blurb.html
```

Then run:

```sh
mkdir -p custom/html/
echo "<p>Hi, this is my custom blurb.</p>" > custom/html/blurb.html
```

Re-generate the website now to see your new text on the front page.

## Advanced templating

Besides plain HTML, template files may also use special _directives_ to perform
variable substitution, conditionally include certain sections, or generate
repetitive HTML using loops.  Each template file is processed using
[Template::Alloy][]'s version of the [Template Toolkit syntax][].  Read more
about the features you can use in [Template Toolkit's manual][].

[Template::Alloy]: https://metacpan.org/pod/distribution/Template-Alloy/lib/Template/Alloy.pod
[Template Toolkit syntax]: http://template-toolkit.org/docs/manual/Syntax.html
[Template Toolkit's manual]: http://template-toolkit.org/docs/manual/


# Your own documentation

Nearly all of ISDB's documentation is written in [Markdown][] and rendered to
HTML by [pandoc][].  You can see the original Markdown files by looking at the
`.md` files in the _doc_ directory of your ISDB tools.

While our documentation covers general ISDB topics, there's almost certainly
information about your specific data that's important to convey.  Perhaps you
want to add a quick start tutorial or show a pertinent example analysis for
your fellow lab members.  For a frequently updated database, change notes are
useful to document updates and corrections.

You can add new documentation pages by editing your `config_local.yaml` to
point to a directory containing additional `.md` files:

```yaml
---
contact: your-email-address@example.com
name: FelineIS
web:
  title: FIV Integration Sites
  template:
    blurb: custom/html/blurb.html
  local_documentation: custom/doc/
```

Note that this directory, `custom/doc/`, is relative the location of your
`config_local.yaml`.  This is useful for keeping them near each other in your
filesystem.

[Markdown]: http://commonmark.org/help/
[pandoc]: http://pandoc.org

## Frontmatter

Each documentation file should contain a metadata block as the first lines of
the file.  This frontmatter provides a document title, topic, and order within
the list of other documentation.

An example metadata block, from HIRIS, is:

```yaml
---
title: Proviral orientations of HIV-1
topic: HIRIS
order: 1
...
```

The document title and topic may be whatever you want.  Documents will be
grouped by topic on the documentation table of contents page.


# Keeping the website up-to-date

As you load new data sources, update existing ones, or update the ISDB software
itself, you'll need to manually run `generate-website` so that your website is
updated with the new information.

Since it's a chore to remember to do manually every time, it's also possible to
run `generate-website` automatically via your system's task scheduler,
[_cron_][].  ISDB includes a handy tool, `bin/cron`, for making that easier.

An example [crontab][], taken from HIRIS, looks like this:

```crontab
PGHOST=hiris.mullins.microbiol.washington.edu
PGUSER=hiris_ro
PGDATABASE=hiris
ISDB_CONFIG=/home/isdb/hiris/config.yaml

15 7 * * * $HOME/isdb/bin/cron --auto-update --commit --push -- $HOME/hiris/website/
```

You can see the options for the ISDB cron tool by running:

```sh
./bin/cron --help
```

[_cron_]: https://en.wikipedia.org/wiki/Cron
[crontab]: http://www.computerhope.com/unix/ucrontab.htm


# Publishing the website

As the website is a simple collection of static files, you can publish it by
copying your website output directory to any web server.

Once you know where you'll publish your website, make sure you set the
`base_url` setting (under the `web` section) in your `config_local.yaml`.  If
you don't do so, links to UCSC Genome Browser, frozen versions of your data,
and some other website features won't work correctly.

If you run `generate-website` automatically to keep the website up-to-date,
make sure you also set up an automatic copy to the web server.  Recommended
transfer methods include `git pull`, `rsync`, SFTP, and SCP.
