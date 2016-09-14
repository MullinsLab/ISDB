use 5.010;
use strict;
use warnings;
use utf8;

package ISDB::Exporter;
use Moo;
use Type::Params qw< compile Invocant >;
use Types::Standard qw< :types slurpy >;
use Types::LoadableClass qw< :types >;
use Path::Tiny;
use JSON::MaybeXS qw<>;
use DateTime;
use Digest::SHA qw<>;
use ISDB::Schema;
use namespace::clean;

has _json => (
    is      => 'ro',
    isa     => Object,
    default => sub {
        JSON::MaybeXS->new
            ->canonical
            ->convert_blessed
            ->pretty
    },
);

has schema => (
    is       => 'ro',
    isa      => InstanceOf['DBIx::Class::Schema'],
    default  => sub { ISDB::Schema->connect_default },
);

has output_path => (
    is       => 'ro',
    isa      => InstanceOf['Path::Tiny'],
    required => 1,
);

my $ExportSpec = Dict[
    name      => Str,
    resultset => InstanceOf['DBIx::Class::ResultSet'],
    filename  => Str,
    slurpy HashRef
];

has exports => (
    is  => 'lazy',
    isa => ArrayRef[ $ExportSpec ],
);

has formats => (
    is      => 'ro',
    isa     => ArrayRef[ ClassDoes['ISDB::Exporter::Formatter'] ],
    default => sub {
        [qw[ ISDB::Exporter::CSV
             ISDB::Exporter::Excel
             ISDB::Exporter::JSON ]]
    },
);

has datetime_formatter => (
    is      => 'lazy',
    isa     => HasMethods['format_datetime'],
    builder => sub {
        require DateTime::Format::RFC3339;
        return DateTime::Format::RFC3339->new;
    },
);

sub BUILD {
    my $self = shift;
    $self->output_path->mkpath
        unless $self->output_path->exists;
}

sub _build_exports {
    my $self = shift;
    my $isdb = $self->schema;
    return [
        {
            name      => 'Summary by gene',
            resultset => $isdb->resultset("SummaryByGene"),
            filename  => 'summary-by-gene',
        },
        {
            name      => 'Integration summary',
            resultset => $isdb->resultset("IntegrationSummary"),
            filename  => 'integration-summary',
        },
        {
            name      => 'Integration summary with annotated genes',
            resultset => $isdb->resultset("IntegrationGeneSummary"),
            filename  => 'integration-gene-summary',
        },
    ];
}

sub export {
    state $params = compile(Invocant, $ExportSpec);
    my ($self, $spec) = $params->(@_);

    my @formats = map {
        $_->new(
            output_path => $self->output_path,
            basename    => $spec->{filename},
        )
    } @{ $self->formats };

    # Result struct we'll return
    my $metafile  = $self->output_path->child("$spec->{filename}.metadata.json");
    my $exported  = {
        name      => $spec->{name},
        metafile  => $metafile->relative( $self->output_path ),
        timestamp => DateTime->now( formatter => $self->datetime_formatter ) . "",
        fields    => [ $spec->{resultset}->result_class->columns ],
        formats   => {
            map {;
                $_->name => {
                    path => $_->filename
                }
            } @formats
        },
    };

    # Write out header, data rows, and footer for each format, only looping
    # through the result set once.
    $_->write_header($exported->{fields})
        for @formats;

    while (my $row = $spec->{resultset}->next) {
        $_->write_row($exported->{fields}, { $row->get_columns })
            for @formats;
    }

    $_->write_footer($exported->{fields})
        for @formats;

    # Destroy formatter objects to close open filehandles, etc.
    undef @formats;

    for my $format (values %{ $exported->{formats} }) {
        # Add checksums for integrity checking and change detection
        my $file = $format->{path};
        my $sha  = Digest::SHA->new(1);
        $sha->addfile( $file->openr_raw );
        $format->{sha1} = $sha->hexdigest;

        # Translate to relative paths for external consumption
        $format->{path} = $format->{path}->relative( $self->output_path );
    }

    # Write metadata files
    $self->write_metadata($metafile, $exported);

    return $exported;
}

# This finds all existing export metadata files in our output path so we
# can inspect previous export state.  It's intentionally not limited to
# whatever we might currently be exporting, as that might be different
# than the past.
sub find_metadata {
    my $self = shift;
    my @exported = map { $self->read_metadata($_) }
                       $self->output_path->children(qr/\.metadata\.json$/);
    return @exported;
}

sub read_metadata {
    my $self = shift;
    my $file = path(shift);
    return $self->_json->decode( $file->slurp_utf8 );
}

sub write_metadata {
    my $self = shift;
    my $file = path(shift);
    my $meta = shift;
    $file->spew_utf8( $self->_json->encode($meta) );
}

1;
