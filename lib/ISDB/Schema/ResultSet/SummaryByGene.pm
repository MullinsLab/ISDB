use 5.010;
use utf8;
use strict;
use warnings;

package ISDB::Schema::ResultSet::SummaryByGene;
use base 'DBIx::Class::ResultSet';
use namespace::clean;

sub in_vivo {
    my $self = shift;
    return $self->search_rs({ environment => 'in vivo' });
}

sub in_vitro {
    my $self = shift;
    return $self->search_rs({ environment => 'in vitro' });
}

sub top_N_by_columns {
    my $self = shift;
    my $rows = shift || 10;
    my @cols = @_ or return undef;
    return $self->search_rs(
        {
            gene => { '!=' => undef }
        },
        {
            order_by => { -desc => \@cols },
            rows     => $rows,
        }
    );
}

sub with_interestingness {
    my $self = shift;
    my $me   = $self->current_source_alias;
    return $self->search_rs(
        {
            gene => { '!=', undef },
        },
        {
            '+columns'  => [{
                interestingness => \["$me.total_in_gene / $me.unique_sites / coalesce($me.subjects, 1) AS interestingness"],
            }],
            order_by    => [
                'interestingness',
                'coalesce(subjects, 1) DESC',
                'unique_sites  DESC',
                'total_in_gene DESC',
            ],
        }
    );
}

1;
