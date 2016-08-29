use utf8;
package ISDB::Schema::Result::SummaryByGene;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ISDB::Schema::Result::SummaryByGene

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<ISDB::Schema::InflateColumn::JSON>

=item * L<ISDB::Schema::SerializableAsJSON>

=back

=cut

__PACKAGE__->load_components(
  "+ISDB::Schema::InflateColumn::JSON",
  "+ISDB::Schema::SerializableAsJSON",
);
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<summary_by_gene>

=cut

__PACKAGE__->table("summary_by_gene");

=head1 ACCESSORS

=head2 ncbi_gene_id

  data_type: 'integer'
  is_nullable: 1

=head2 gene

  data_type: 'text'
  is_nullable: 1

=head2 subjects

  data_type: 'bigint'
  is_nullable: 1

=head2 unique_sites

  data_type: 'bigint'
  is_nullable: 1

=head2 proliferating_sites

  data_type: 'bigint'
  is_nullable: 1

=head2 total_in_gene

  data_type: 'numeric'
  is_nullable: 1

=head2 environments

  data_type: 'text[]'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "ncbi_gene_id",
  { data_type => "integer", is_nullable => 1 },
  "gene",
  { data_type => "text", is_nullable => 1 },
  "subjects",
  { data_type => "bigint", is_nullable => 1 },
  "unique_sites",
  { data_type => "bigint", is_nullable => 1 },
  "proliferating_sites",
  { data_type => "bigint", is_nullable => 1 },
  "total_in_gene",
  { data_type => "numeric", is_nullable => 1 },
  "environments",
  { data_type => "text[]", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-08-25 13:58:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:woFemn0xVvgnmtrhtXrlZw

=head2 ncbi_gene

Type: belongs_to

Related object: L<ISDB::Schema::Result::NCBIGene>

=cut

__PACKAGE__->belongs_to(
  "ncbi_gene",
  "ISDB::Schema::Result::NCBIGene",
  { ncbi_gene_id => "ncbi_gene_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 gene_locations

Type: has_many

Related object: L<ISDB::Schema::Result::NCBIGeneLocation>

=cut

__PACKAGE__->has_many(
  "gene_locations",
  "ISDB::Schema::Result::NCBIGeneLocation",
  { "foreign.ncbi_gene_id" => "self.ncbi_gene_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

sub as_hash {
    my $self = shift;
    return {
        $self->get_columns,
        ncbi_gene => $self->ncbi_gene->as_hash,
    };
}

1;
