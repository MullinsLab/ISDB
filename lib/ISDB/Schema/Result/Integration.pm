use utf8;
package ISDB::Schema::Result::Integration;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ISDB::Schema::Result::Integration

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

=head1 TABLE: C<integration>

=cut

__PACKAGE__->table("integration");

=head1 ACCESSORS

=head2 source_name

  accessor: 'source'
  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 255

=head2 sample

  data_type: 'jsonb'
  is_nullable: 1

=head2 ltr

  data_type: 'ltr_end'
  is_nullable: 1

=head2 refseq_accession

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 chromosome

  data_type: 'human_chromosome'
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

=head2 ncbi_gene_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 sequence

  accessor: 'seq'
  data_type: 'text'
  is_nullable: 1

=head2 sequence_junction

  data_type: 'integer'
  is_nullable: 1

=head2 note

  data_type: 'text'
  is_nullable: 1

=head2 info

  data_type: 'jsonb'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "source_name",
  {
    accessor => "source",
    data_type => "varchar",
    is_foreign_key => 1,
    is_nullable => 0,
    size => 255,
  },
  "sample",
  { data_type => "jsonb", is_nullable => 1 },
  "ltr",
  { data_type => "ltr_end", is_nullable => 1 },
  "refseq_accession",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "chromosome",
  { data_type => "human_chromosome", is_nullable => 1 },
  "location",
  { data_type => "integer", is_nullable => 1 },
  "orientation_in_reference",
  { data_type => "orientation", is_nullable => 1 },
  "orientation_in_gene",
  { data_type => "orientation", is_nullable => 1 },
  "ncbi_gene_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "sequence",
  { accessor => "seq", data_type => "text", is_nullable => 1 },
  "sequence_junction",
  { data_type => "integer", is_nullable => 1 },
  "note",
  { data_type => "text", is_nullable => 1 },
  "info",
  { data_type => "jsonb", is_nullable => 1 },
);

=head1 RELATIONS

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

=head2 source

Type: belongs_to

Related object: L<ISDB::Schema::Result::Source>

=cut

__PACKAGE__->belongs_to(
  "source",
  "ISDB::Schema::Result::Source",
  { source_name => "source_name" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-21 15:04:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8kfdb3hoGqcgLFTY1zg/9Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
