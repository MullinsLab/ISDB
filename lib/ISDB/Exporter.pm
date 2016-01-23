use 5.010;
use strict;
use warnings;
use utf8;

package ISDB::Exporter;
use Moo;
use Type::Params qw< compile Invocant >;
use Types::Standard qw< :types slurpy >;
use Path::Tiny;
use JSON::MaybeXS qw<>;
use DateTime;
use ISDB::Schema;
use ISDB::Exporter::CSV;
use ISDB::Exporter::JSON;
use namespace::clean;

has _json => (
    is      => 'ro',
    isa     => Object,
    default => sub {
        JSON::MaybeXS->new
            ->utf8
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
    is  => 'lazy',
    isa => ArrayRef[ ConsumerOf['ISDB::Exporter::Formatter'] ],
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
    ];
}

sub _build_formats {
    my $self = shift;
    return [
        ISDB::Exporter::CSV->new,
        ISDB::Exporter::JSON->new,
    ];
}

sub export {
    state $params = compile(Invocant, $ExportSpec);
    my ($self, $spec) = $params->(@_);

    # Result struct we'll return
    my @formats   = @{ $self->formats };
    my $basepath  = $self->output_path->child($spec->{filename});
    my $exported  = {
        name      => $spec->{name},
        timestamp => DateTime->now( formatter => $self->datetime_formatter ) . "",
        fields    => [ $spec->{resultset}->result_class->columns ],
        formats   => {
            map {;
                $_->extension => {
                    path => path(join ".", $basepath, $_->extension)
                }
            } @formats
        },
    };

    # Write out header, data rows, and footer for each format, only looping
    # through the result set once.
    my %fh = map { $_ => $exported->{formats}{$_->extension}{path}->openw_utf8 } @formats;
    $_->write_header($fh{$_}, $exported->{fields})
        for @formats;

    while (my $row = $spec->{resultset}->next) {
        $_->write_row($fh{$_}, $exported->{fields}, { $row->get_columns })
            for @formats;
    }

    $_->write_footer($fh{$_}, $exported->{fields})
        for @formats;

    $_->close or die "Failed to close fh: $!"
        for values %fh;

    # Write metadata files
    my $meta = path("$basepath.metadata.json");
    $meta->spew_utf8( $self->_json->encode($exported) );

    return $exported;
}

1;
