use 5.010;
use utf8;
use strict;
use warnings;

package ISDB::Schema::ResultSet::IntegrationGene;
use base 'DBIx::Class::ResultSet';
use namespace::clean;

sub count_distinct_genes {
    my $self = shift;
    return $self->search_rs({}, {
        columns  => [ 'ncbi_gene_id' ],
        distinct => 1,
    })->count;
}

1;
