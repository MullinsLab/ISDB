use utf8;
package ISDB::Schema::Result::IntegrationSummary;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ISDB::Schema::Result::IntegrationSummary

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<ISDB::Schema::InflateColumn::JSON>

=back

=cut

__PACKAGE__->load_components("+ISDB::Schema::InflateColumn::JSON");
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<integration_summary>

=cut

__PACKAGE__->table("integration_summary");

=head1 ACCESSORS

=head2 source_name

  accessor: 'source'
  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 subject

  data_type: 'text'
  is_nullable: 1

=head2 ncbi_gene_id

  data_type: 'integer'
  is_nullable: 1

=head2 gene

  data_type: 'text'
  is_nullable: 1

=head2 landmark

  data_type: 'text'
  is_nullable: 1

=head2 location

  data_type: 'integer'
  is_nullable: 1

=head2 orientation_in_reference

  data_type: 'orientation'
  is_nullable: 1

=head2 orientation_in_gene

  data_type: 'orientation'
  is_nullable: 1

=head2 multiplicity

  data_type: 'bigint'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "source_name",
  { accessor => "source", data_type => "varchar", is_nullable => 1, size => 255 },
  "subject",
  { data_type => "text", is_nullable => 1 },
  "ncbi_gene_id",
  { data_type => "integer", is_nullable => 1 },
  "gene",
  { data_type => "text", is_nullable => 1 },
  "landmark",
  { data_type => "text", is_nullable => 1 },
  "location",
  { data_type => "integer", is_nullable => 1 },
  "orientation_in_reference",
  { data_type => "orientation", is_nullable => 1 },
  "orientation_in_gene",
  { data_type => "orientation", is_nullable => 1 },
  "multiplicity",
  { data_type => "bigint", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-22 10:03:34
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FCdl/zFGdTAVitHnONXjYg

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

1;
