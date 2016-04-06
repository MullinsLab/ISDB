use 5.010;
use utf8;
use strict;
use warnings;

package ISDB::Schema::ResultSet::Integration;
use base 'DBIx::Class::ResultSet';
use namespace::clean;

sub counts_by_source_and_publication {
    my $self   = shift;
    my $me     = $self->current_source_alias;
    my $pubmed = "$me.sample->>'pubmed_id'";
    return $self->search_rs({}, {
        columns  => [ "$me.source_name", { pubmed_id => \[$pubmed] }, { count => { COUNT => 1 } } ],
        group_by => [ "$me.source_name", $pubmed ],
        order_by => [ "$pubmed != ''", "$me.source_name", $pubmed ],
    });
}

sub publications {
    my $self   = shift;
    my $me     = $self->current_source_alias;
    my $pubmed = "$me.sample->>'pubmed_id'";
    return $self->search_rs(
        \["$pubmed != ''"],
        {
            columns  => [ { pubmed_id => \[$pubmed] } ],
            distinct => 1,
        },
    );
}

sub in_vivo {
    my $self = shift;
    return $self->search_rs( environment => 'in vivo' );
}

sub in_vitro {
    my $self = shift;
    return $self->search_rs( environment => 'in vitro' );
}

1;
