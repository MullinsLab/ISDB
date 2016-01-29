use 5.010;
use strict;
use warnings;
use utf8;

package ISDB::Exporter::Formatter;
use Moo::Role;
use Types::Standard qw< :types >;
use namespace::clean;

has name => (
    is      => 'ro',
    isa     => Str,
    builder => sub { (split /::/, ref $_[0])[-1] },
);

requires qw[ write_header write_row write_footer extension name ];

1;
