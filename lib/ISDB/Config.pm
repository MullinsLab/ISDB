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

sub _read_conf {
    my $self = shift;
    my $conf = Config::Any->load_stems({
        stems   => $self->stems,
        use_ext => 1,

        # Allow the use of [] to make Config::General settings explicitly an
        # array even if only used once.
        driver_args => {
            General => { -ForceArray => 1 },
        },
    });
    return reduce { merge($a, $b) } +{},
              map { pairvalues %$_ }
                  @$conf;
}

sub _build_conf {
    my $self = shift;
    my $conf = $self->_read_conf;

    # Normalize base_url
    $conf->{web}{base_url} .= "/"
        unless not exists $conf->{web}{base_url}
            or $conf->{web}{base_url} =~ m{/$};

    return $conf;
}

1;
