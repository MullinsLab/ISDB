use 5.010;
use strict;
use warnings;
use utf8;

package ISDB::Exporter::CSV;
use Moo;
use Types::Standard qw< :types >;
use Text::CSV;
use namespace::clean;

has _csv => (
    is      => 'ro',
    isa     => InstanceOf['Text::CSV'],
    default => sub {
        my $csv = Text::CSV->new({ binary => 1, eol => "\n" })
            or die 'Text::CSV->new failed: ' . Text::CSV->error_diag;
        return $csv;
    },
);

has extension => (
    is      => 'ro',
    isa     => Str,
    default => 'csv',
);

with 'ISDB::Exporter::Formatter';

sub write_header {
    my ($self, $fh, $fields) = @_;
    $self->_csv->print($fh, $fields);
}

sub write_row {
    my ($self, $fh, $fields, $row) = @_;
    $self->_csv->print($fh, [ map { $self->format_value($_) } @$row{ @$fields } ]);
}

sub write_footer { }

sub format_value {
    my $self  = shift;
    my $value = shift;
    $value = join "|", grep { defined } @$value
        if ref $value eq "ARRAY";
    return $value;
}

1;
