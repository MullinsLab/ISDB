use utf8;
package ISDB::Schema::Result::Source;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ISDB::Schema::Result::Source

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

=head1 TABLE: C<source>

=cut

__PACKAGE__->table("source");

=head1 ACCESSORS

=head2 source_name

  accessor: 'source'
  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 document

  data_type: 'jsonb'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "source_name",
  { accessor => "source", data_type => "varchar", is_nullable => 0, size => 255 },
  "document",
  { data_type => "jsonb", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</source_name>

=back

=cut

__PACKAGE__->set_primary_key("source_name");

=head1 RELATIONS

=head2 integrations

Type: has_many

Related object: L<ISDB::Schema::Result::Integration>

=cut

__PACKAGE__->has_many(
  "integrations",
  "ISDB::Schema::Result::Integration",
  { "foreign.source_name" => "self.source_name" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-08-25 13:58:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Fzw/lwJojEbfralOcUv0Wg

__PACKAGE__->add_columns("+source_name" => { accessor => "name" });

sub as_hash {
    my $self = shift;
    return {
        $self->get_columns,
        document => $self->document,
    };
}

1;
