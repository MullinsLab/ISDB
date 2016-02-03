use 5.010;
use utf8;
use strict;
use warnings;

package ISDB::Schema::ResultSet::NCBIGene;
use base 'DBIx::Class::ResultSet';
use Scalar::Util qw< refaddr >;
use namespace::clean;

# This is optimized to make three super-quick queries of the form:
#
#   SELECT ncbi_gene_id FROM ncbi_gene       WHERE UPPER(name) = UPPER(?)
#   SELECT ncbi_gene_id FROM ncbi_gene_alias WHERE UPPER(name) = UPPER(?)
#   SELECT *            FROM ncbi_gene       WHERE ncbi_gene_id IN (?)
#
# instead of one query involving a join.  It trades implementation simplicity
# for a huge speed-up.  Since we do this for every integration, it makes quite
# a bit of difference (~300ms/call → ~0.3ms/call!) during validation/load.
# -trs, 4 Dec 2015
sub search_by_name {
    my $self = shift;
    my $name = shift;
    my @sources = (
        $self->result_source->resultset,
        $self->result_source->schema->resultset('NCBIGeneAlias'),
    );

    my %genes;
    for my $rs (@sources) {
        my @ids = map { $_->ncbi_gene_id } $rs->search(
            [ \[ 'UPPER(name) = UPPER(?)', $name ] ],
            { columns => ['ncbi_gene_id'] },
        );
        $genes{$_} = 1 for @ids;
    }
    return $self->search({
        ncbi_gene_id => [keys %genes],
    });
}

sub find_best {
    my ($self, $fields) = @_;

    my $id   = $fields->{ncbi_gene_id};
    my $name = $fields->{name};
    return undef unless $id or $name;

    # Handle LOCNNNNNN specially.  The numeric part is doc'd to be
    # equal to the gene ID:
    #   http://www.ncbi.nlm.nih.gov/books/NBK3840/#genefaq.Conventions
    $id ||= $1 if $name and $name =~ /^LOC(\d+)$/;

    my $by_id   = $self->find({ ncbi_gene_id => $id });
    my @by_name = $self->search_by_name($name);

    if ($by_id) {
        # We're going to use the given gene ID, but let's cross-check it
        # against any given name first.
        if (@by_name > 1) {
            unless (grep { $_->id == $by_id->id } @by_name) {
                warn "Many genes found with name «$name», ",
                     "but none match the given gene ID «$id», using ID $id\n";
            }
        }
        elsif (@by_name == 1) {
            unless ($by_id->id == $by_name[0]->id) {
                warn sprintf "Gene ID (%d [%s]) and name (%s [%d]) don't match, using ID %d\n",
                    $by_id->id, $by_id->name, $by_name[0]->name, $by_name[0]->id, $by_id->id;
            }
        }
        elsif ($name) {
            warn "Gene name «$name» given but not found in database, using ID $id\n";
        }
        return $by_id;
    }
    elsif (@by_name) {
        warn "Gene ID «$id» given but not found in database, trying name «$name»\n"
            if $id;

        # ID wasn't given or didn't work, so let's find a gene by name.
        if (@by_name > 1) {
            die "Gene name «$name» matches many IDs: ",
                join(", ", map { $_->id } @by_name), "\n";
        }
        else {
            return $by_name[0];
        }
    } else {
        $id   //= "(none)";
        $name //= "(none)";
        warn "No gene found by ID «$id» or name «$name»\n";
    }
    return undef;
}

sub find_best_cached {
    my ($self, $fields) = @_;
    my $key = join "\x1e", map { $fields->{$_} // '' } sort keys %$fields;

    state $cache = {};
    return $cache->{refaddr $self}{$key} ||= $self->find_best($fields);
}

1;
