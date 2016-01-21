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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-21 15:03:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oEY+e+rmODsdnyUn3M+X2A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
