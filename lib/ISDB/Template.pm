use 5.010;
use strict;
use warnings;
use utf8;

package ISDB::Template;
use Template::Alloy;
use ISDB::Schema;
use Hash::Merge qw< merge >;
use namespace::clean;

sub fill {
    my $self     = shift;
    my $source   = shift;
    my $args     = shift || {};
    my $isdb     = ISDB::Schema->connect_default;
    my $defaults = {
        isdb => $isdb,
    };
    $args = merge($args, $defaults);

    state $template = Template::Alloy->new(
        START_TAG   => '<%',
        END_TAG     => '%>',
        AUTO_FILTER => 'html',
        ENCODING    => 'UTF-8',
        ABSOLUTE    => 1,
        STRICT      => 1,
        FILTERS     => {
            commafy => sub {
                my $num = shift // return undef;
                   $num = reverse $num;
                   $num =~ s/(?<=\G\d{3})(?!$)/,/g;
                   $num = reverse $num;
                return $num;
            },
        },
    );
    my $filled = "";
    $template->process($source, $args, \$filled)
        or die $template->error, "\n";
    return $filled;
}

1;
