use utf8;
package ISDB::Schema::Result::SummaryByGene;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ISDB::Schema::Result::SummaryByGene

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
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<summary_by_gene>

=cut

__PACKAGE__->table("summary_by_gene");

=head1 ACCESSORS

=head2 gene

  data_type: 'text'
  is_nullable: 1

=head2 subjects

  data_type: 'bigint'
  is_nullable: 1

=head2 unique_sites

  data_type: 'bigint'
  is_nullable: 1

=head2 total_in_gene

  data_type: 'numeric'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "gene",
  { data_type => "text", is_nullable => 1 },
  "subjects",
  { data_type => "bigint", is_nullable => 1 },
  "unique_sites",
  { data_type => "bigint", is_nullable => 1 },
  "total_in_gene",
  { data_type => "numeric", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-21 15:04:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RUGReo9cIFSiVUSO5DI0eQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
