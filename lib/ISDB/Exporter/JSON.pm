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
    default => sub { JSON->new->canonical },
);

has _fh => (
    is      => 'lazy',
    isa     => FileHandle,
    builder => sub { $_[0]->filename->openw_utf8 },
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
    my ($self) = @_;
    print { $self->_fh } "[";
    $self->_first_row(1);
}

sub write_row {
    my ($self, $fields, $row) = @_;
    if ($self->_first_row) {
        $self->_first_row(0);
    } else {
        print { $self->_fh } "\n,";
    }
    print { $self->_fh } $self->_json->encode($row);
}

sub write_footer {
    my ($self) = @_;
    print { $self->_fh } "]\n";
}

1;
