use utf8;
package ISDB::Schema::Result::NCBIGeneLocation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ISDB::Schema::Result::NCBIGeneLocation

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

=head1 TABLE: C<ncbi_gene_location>

=cut

__PACKAGE__->table("ncbi_gene_location");

=head1 ACCESSORS

=head2 ncbi_gene_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 landmark

  data_type: 'landmark'
  is_nullable: 0

=head2 gene_start

  data_type: 'integer'
  is_nullable: 0

=head2 gene_end

  data_type: 'integer'
  is_nullable: 0

=head2 gene_orientation

  data_type: 'orientation'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "ncbi_gene_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "landmark",
  { data_type => "landmark", is_nullable => 0 },
  "gene_start",
  { data_type => "integer", is_nullable => 0 },
  "gene_end",
  { data_type => "integer", is_nullable => 0 },
  "gene_orientation",
  { data_type => "orientation", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</ncbi_gene_id>

=item * L</landmark>

=item * L</gene_start>

=back

=cut

__PACKAGE__->set_primary_key("ncbi_gene_id", "landmark", "gene_start");

=head1 RELATIONS

=head2 ncbi_gene

Type: belongs_to

Related object: L<ISDB::Schema::Result::NCBIGene>

=cut

__PACKAGE__->belongs_to(
  "ncbi_gene",
  "ISDB::Schema::Result::NCBIGene",
  { ncbi_gene_id => "ncbi_gene_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-08-25 13:58:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ilv2QwrKZ7zFR3Dl3M+ypA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
