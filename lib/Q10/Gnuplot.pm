package Q10::Gnuplot;
use strict;
use warnings;
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;
use Q10::Parser;

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
    my $statement       = $arg{statement} or return;
    my $fit_file_name   = $arg{fit_file_name} || dir($Bin, 'temp')->file('fit.plt');
    my $log_file_name   = $arg{log_file_name} || dir($Bin, 'temp')->file('log.txt');
    my $param_file_name = $arg{param_file_name} || dir($Bin, 'temp')->file('param.txt');
    my $fit_file        = IO::File->new($fit_file_name, 'w');
    $fit_file->print (qq{$statement
save var '$param_file_name'
});
    $fit_file->close;
    my $com = qq{gnuplot $fit_file_name &>$log_file_name};
    system $com;
    -e $param_file_name or return;
    Q10::Parser->parse($param_file_name);
}

1;
