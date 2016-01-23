use 5.010;
use strict;
use warnings;
use utf8;

package ISDB::Exporter::Formatter;
use Moo::Role;

requires qw[ write_header write_row write_footer extension ];

1;
