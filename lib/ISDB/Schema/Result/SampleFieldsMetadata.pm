use utf8;
package ISDB::Schema::Result::SampleFieldsMetadata;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ISDB::Schema::Result::SampleFieldsMetadata

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

=head1 TABLE: C<sample_fields_metadata>

=cut

__PACKAGE__->table("sample_fields_metadata");

=head1 ACCESSORS

=head2 field

  data_type: 'text'
  is_nullable: 1

=head2 count

  data_type: 'bigint'
  is_nullable: 1

=head2 values

  data_type: 'bigint'
  is_nullable: 1

=head2 sources

  data_type: 'character varying[]'
  is_nullable: 1

=head2 environments

  data_type: 'text[]'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "field",
  { data_type => "text", is_nullable => 1 },
  "count",
  { data_type => "bigint", is_nullable => 1 },
  "values",
  { data_type => "bigint", is_nullable => 1 },
  "sources",
  { data_type => "character varying[]", is_nullable => 1 },
  "environments",
  { data_type => "text[]", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-08-25 13:58:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LHnomXmmKtYh0CjXLEg29A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
