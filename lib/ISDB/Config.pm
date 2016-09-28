use 5.010;
package ISDB::Config;
use Moo;
use Types::Standard qw< :types >;
use Types::Common::String qw< NonEmptyStr >;
use Config::Any;
use Hash::Merge qw< merge >;
use List::Util qw< reduce pairvalues >;
use Path::Tiny;
use namespace::clean;

has files => (
    is       => 'lazy',
    isa      => ArrayRef[NonEmptyStr],
);

has stems => (
    is       => 'ro',
    isa      => ArrayRef[NonEmptyStr],
    required => 1,
    default  => sub {[
        # Stem order is important for precedence
        map { path(__FILE__)->parent(3)->child($_)->stringify }
            qw[ config_local config ]
    ]},
);

has conf => (
    is       => 'lazy',
    isa      => HashRef,
    init_arg => undef,
);

sub _build_files {
    my $self = shift;
    my @files;

    # Directly specified config file
    push @files, $ENV{ISDB_CONFIG} if $ENV{ISDB_CONFIG};

    # Cross stems by extensions, the same as Config::Any->load_stems
    for my $stem (@{ $self->stems }) {
        for my $ext (Config::Any->extensions) {
            push @files, "$stem.$ext";
        }
    }
    return \@files;
}

sub _build_conf {
    my $self = shift;
    my $conf = Config::Any->load_files({
        files   => $self->files,
        use_ext => 1,

        # Allow the use of [] to make Config::General settings explicitly an
        # array even if only used once.
        driver_args => {
            General => { -ForceArray => 1 },
        },
    });
    return reduce { merge($a, $b) } +{},
              map { _normalize_conf(%$_) }
                  @$conf;
}

sub _normalize_conf {
    my ($file, $conf) = @_;

    # Normalize base_url
    $conf->{web}{base_url} .= "/"
        unless not exists $conf->{web}{base_url}
            or $conf->{web}{base_url} =~ m{/$};

    # Resolve custom template paths relative to the config file itself not our
    # current working dir
    for my $tmpl (values %{ $conf->{web}{template} || {} }, $conf->{web}{local_documentation}) {
        next unless defined $tmpl;
        $tmpl = path($tmpl)->absolute( path($file)->parent )->stringify
            if path($tmpl)->is_relative;
    }

    return $conf;
}

1;
