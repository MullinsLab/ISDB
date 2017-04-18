use 5.010;
use strict;
use warnings;
package ISDB::Types;

use Type::Library
    -base,
    -declare => qw< SampleMetadata >;
use Type::Utils -all;
use Types::Standard qw< :types slurpy >;
use Types::Common::String qw< :types >;

# Maybe someday we'll want to use a JSON schema (http://json-schema.org/) via
# JSON::Schema, JSON::Schema::AsType, or otherwise, but this is quick and easy
# and low-dep and still gets us nice validation.
# -trs, 2 Dec 2015
declare "SourceMetadata",
    as Dict[
        name    => NonEmptySimpleStr,
        uri     => NonEmptySimpleStr,
        slurpy HashRef
    ]
;

1;
