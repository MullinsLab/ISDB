use utf8;
package ISDB::Schema::Result::NCBIGene;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ISDB::Schema::Result::NCBIGene

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

=head1 TABLE: C<ncbi_gene>

=cut

__PACKAGE__->table("ncbi_gene");

=head1 ACCESSORS

=head2 ncbi_gene_id

  data_type: 'integer'
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "ncbi_gene_id",
  { data_type => "integer", is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</ncbi_gene_id>

=back

=cut

__PACKAGE__->set_primary_key("ncbi_gene_id");

=head1 RELATIONS

=head2 aliases

Type: has_many

Related object: L<ISDB::Schema::Result::NCBIGeneAlias>

=cut

__PACKAGE__->has_many(
  "aliases",
  "ISDB::Schema::Result::NCBIGeneAlias",
  { "foreign.ncbi_gene_id" => "self.ncbi_gene_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 integrations

Type: has_many

Related object: L<ISDB::Schema::Result::Integration>

=cut

__PACKAGE__->has_many(
  "integrations",
  "ISDB::Schema::Result::Integration",
  { "foreign.ncbi_gene_id" => "self.ncbi_gene_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-21 15:04:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:p15tTjrmRkEIWHu2+1yPpg

use URI;

sub uri {
    my $self = shift;
    return URI->new("https://www.ncbi.nlm.nih.gov/gene/" . $self->id);
}

1;
