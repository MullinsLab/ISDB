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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-12-02 17:03:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:W3Xe7lGCIjCrU//y8QhnXg

__PACKAGE__->add_columns("+source_name" => { accessor => "name" });

1;
