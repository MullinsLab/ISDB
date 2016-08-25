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

=item * L<ISDB::Schema::SerializableAsJSON>

=back

=cut

__PACKAGE__->load_components(
  "+ISDB::Schema::InflateColumn::JSON",
  "+ISDB::Schema::SerializableAsJSON",
);
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<integration_summary>

=cut

__PACKAGE__->table("integration_summary");

=head1 ACCESSORS

=head2 environment

  data_type: 'integration_environment'
  is_nullable: 1

=head2 subject

  data_type: 'text'
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

=head2 multiplicity

  data_type: 'bigint'
  is_nullable: 1

=head2 source_names

  data_type: 'character varying[]'
  is_nullable: 1

=head2 pubmed_ids

  data_type: 'integer[]'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "environment",
  { data_type => "integration_environment", is_nullable => 1 },
  "subject",
  { data_type => "text", is_nullable => 1 },
  "landmark",
  { data_type => "landmark", is_nullable => 1 },
  "location",
  { data_type => "integer", is_nullable => 1 },
  "orientation_in_landmark",
  { data_type => "orientation", is_nullable => 1 },
  "multiplicity",
  { data_type => "bigint", is_nullable => 1 },
  "source_names",
  { data_type => "character varying[]", is_nullable => 1 },
  "pubmed_ids",
  { data_type => "integer[]", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-08-25 13:58:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WneOFM9Vl+nXkAwdVdjPcQ

1;
