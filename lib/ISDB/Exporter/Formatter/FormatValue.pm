use 5.010;
use strict;
use warnings;
use utf8;

package ISDB::Exporter::Formatter::FormatValue;
use Moo::Role;
use namespace::clean;

sub format_value {
    my $self  = shift;
    my $value = shift;
    $value = join "|", grep { defined } @$value
        if ref $value eq "ARRAY";
    return $value;
}

1;
