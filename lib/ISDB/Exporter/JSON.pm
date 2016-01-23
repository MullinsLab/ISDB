use 5.010;
use strict;
use warnings;
use utf8;

package ISDB::Exporter::JSON;
use Moo;
use Types::Standard qw< :types >;
use JSON::MaybeXS;
use namespace::clean;

has _json => (
    is      => 'ro',
    isa     => Object,
    default => sub { JSON->new->utf8->canonical },
);

has extension => (
    is      => 'ro',
    isa     => Str,
    default => 'json',
);

has _first_row => (
    is      => 'rw',
    isa     => Bool,
    default => 1,
);

with 'ISDB::Exporter::Formatter';

sub write_header {
    my ($self, $fh) = @_;
    print { $fh } "[";
    $self->_first_row(1);
}

sub write_row {
    my ($self, $fh, $fields, $row) = @_;
    if ($self->_first_row) {
        $self->_first_row(0);
    } else {
        print { $fh } "\n,";
    }
    print { $fh } $self->_json->encode($row);
}

sub write_footer { print { $_[1] } "]" }

1;
