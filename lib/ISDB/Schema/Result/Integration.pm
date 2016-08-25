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

=item * L<ISDB::Schema::SerializableAsJSON>

=back

=cut

__PACKAGE__->load_components(
  "+ISDB::Schema::InflateColumn::JSON",
  "+ISDB::Schema::SerializableAsJSON",
);

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

=head2 environment

  data_type: 'integration_environment'
  is_nullable: 0

=head2 sample

  data_type: 'jsonb'
  is_nullable: 1

=head2 ltr

  data_type: 'ltr_end'
  is_nullable: 1

=head2 landmark

  data_type: 'landmark'
  is_nullable: 1

=head2 location

  data_type: 'integer'
  is_nullable: 1

=head2 orientation_in_landmark

  data_type: 'orientation'
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
  "environment",
  { data_type => "integration_environment", is_nullable => 0 },
  "sample",
  { data_type => "jsonb", is_nullable => 1 },
  "ltr",
  { data_type => "ltr_end", is_nullable => 1 },
  "landmark",
  { data_type => "landmark", is_nullable => 1 },
  "location",
  { data_type => "integer", is_nullable => 1 },
  "orientation_in_landmark",
  { data_type => "orientation", is_nullable => 1 },
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


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-08-25 13:58:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8hsfHgS2T9Wz4Rp2hl9W+Q

sub as_hash {
    my $self = shift;
    return {
        $self->get_columns,
        sample  => $self->sample,
        info    => $self->info,
    };
}

1;
