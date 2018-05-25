use 5.010;
use strict;
use warnings;
use utf8;

package ISDB::Exporter::JS;
use Moo;
use JSON::MaybeXS;
use namespace::clean;

extends 'ISDB::Exporter::JSON';

has '+extension', default => 'js';

sub write_header {
    my $self = shift;
    my $name = JSON->new->allow_nonref->encode($self->basename);

    print { $self->_fh } <<"    JS";
if (!window.ISDB)         window.ISDB = {};
if (!window.ISDB.Exports) window.ISDB.Exports = {};
window.ISDB.Exports[$name] =
    JS

    $self->next::method(@_);
}

1;
