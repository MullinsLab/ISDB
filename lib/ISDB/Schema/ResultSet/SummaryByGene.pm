use 5.010;
use utf8;
use strict;
use warnings;

package ISDB::Schema::ResultSet::SummaryByGene;
use base 'DBIx::Class::ResultSet';
use namespace::clean;

sub top_N_by_column {
    my $self = shift;
    my $col  = shift or return undef;
    my $rows = shift || 10;
    return $self->search_rs(
        {
            gene => { '!=' => undef }
        },
        {
            order_by => { -desc => $col },
            rows     => $rows,
        }
    );
}

1;
