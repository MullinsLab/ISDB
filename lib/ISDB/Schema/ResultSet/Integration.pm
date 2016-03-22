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

sub counts_by_publication {
    my $self   = shift;
    my $me     = $self->current_source_alias;
    return $self->publications->search_rs({}, {
        '+columns' => [ { count => { COUNT => 1 } } ],
        group_by => \["$me.sample->>'pubmed_id'"],
        order_by => \["$me.sample->>'pubmed_id'"],
        distinct => 0,
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
    my $me   = $self->current_source_alias;
    return $self->search_rs( \["$me.sample->>'integration_environment' IN ('in vivo', '')"] );
}

sub in_vitro {
    my $self = shift;
    my $me   = $self->current_source_alias;
    return $self->search_rs( \["$me.sample->>'integration_environment' IN ('in vitro')"] );
}

1;
