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

has output_path => (
    is       => 'ro',
    isa      => InstanceOf['Path::Tiny'],
    required => 1,
);

has basename => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has filename => (
    is       => 'lazy',
    isa      => InstanceOf['Path::Tiny'],
    builder  => sub {
        my $self = shift;
        return $self->output_path->child(join ".", $self->basename, $self->extension);
    },
);

requires qw[ write_header write_row write_footer extension name ];

1;
