use utf8;
package ISDB::Schema::Result::NCBIGeneAlias;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ISDB::Schema::Result::NCBIGeneAlias

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

=head1 TABLE: C<ncbi_gene_alias>

=cut

__PACKAGE__->table("ncbi_gene_alias");

=head1 ACCESSORS

=head2 ncbi_gene_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "ncbi_gene_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</ncbi_gene_id>

=item * L</name>

=back

=cut

__PACKAGE__->set_primary_key("ncbi_gene_id", "name");

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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-21 15:04:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6aIuSMwFXIQIZj+lJk1hCQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
