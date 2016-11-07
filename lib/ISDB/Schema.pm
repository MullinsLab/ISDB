use utf8;
package ISDB::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-12-02 17:00:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:v0gwY6SVU5Sc1FGqiUXwUw

sub default_connection_info {
    my $dbname = $ENV{PGDATABASE} || 'isdb';
    return {
        dsn             => "dbi:Pg:dbname=$dbname;client_encoding=utf8",
        pg_enable_utf8  => 1,
        on_connect_do   => [],
    };
}

sub connect_default {
    my $self = shift;
    return $self->connect( $self->default_connection_info );
}

1;
