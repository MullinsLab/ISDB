use 5.010;
use utf8;
use strict;
use warnings;

package ISDB::Schema::ResultSet::Integration;
use base 'DBIx::Class::ResultSet';
use namespace::clean;

sub counts_by_source {
    my $self = shift;
    my $me   = $self->current_source_alias;
    return $self->search_rs({}, {
        columns  => [ "$me.source_name", { count => { COUNT => 1 } } ],
        group_by => "$me.source_name",
        order_by => "$me.source_name",
        prefetch => 'source',
    });
}

sub count_distinct_genes {
    my $self = shift;
    return $self->search_rs({}, {
        columns  => [ 'ncbi_gene_id' ],
        distinct => 1,
    })->count;
}

1;
