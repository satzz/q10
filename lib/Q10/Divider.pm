package Q10::Divider;
use strict;
use warnings;
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;

use UNIVERSAL::require;
use Exporter::Lite;

our @EXPORT = qw/divider/;

sub divider (@) {
    my $divider = shift or return __PACKAGE__;
    $divider = "Q10::Divider::$divider";
    $divider->require or die $@;
    $divider;
}

1;
