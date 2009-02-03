package Q10::Gnuplot;
use strict;
use warnings;
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;

sub run{
    my $class = shift;
    my $plt_file_name = shift or return;
    system qq{gnuplot $plt_file_name};
}

sub convert {
    my $class = shift;
    my $ps_file_name = shift or return;
    my $img_file_name = shift or return;
    system qq{convert $ps_file_name $img_file_name};
    system qq{convert -rotate 90 $img_file_name $img_file_name};
}

sub get_param {
    my $class = shift;
    my %arg = @_;
    my $fit_file_name   = $arg{fit_file_name};
    my $target          = $arg{target};
    my $param_file_name = $arg{param_file_name};
    my $param           = $arg{param};
    return 0;
}

1;
