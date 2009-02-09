use strict;
use warnings;
use lib qw{./lib};
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;
use Q10::MoCo;
use Q10::Gnuplot;

my $dat_dir = dir($Bin, qw/ graph dat /);
my $plt_dir = dir($Bin, qw/ graph plt /);
my $ps_dir  = dir($Bin, qw/ graph ps /);
my $img_dir = dir($Bin, qw/ graph img /);
my $param_dir = dir($Bin, qw/ graph param /);
my $log_dir = dir($Bin, qw/ graph log /);

{
    my $index = -1;
    my @plot;
    my $plot;
    my $out;
    my ($old_p8_ratio, $p8_ratio);
    my @dls_trial = moco('DLSTrialCellSample')->search(order => 'p8_ratio desc');
    my $dat_file_name = $dat_dir->file('relaxation_time_ensemble_p8_ratio.dat');
    my $plt_file_name = $plt_dir->file('relaxation_time_ensemble_p8_ratio.plt');
    my $ps_file_name  = $ps_dir->file('relaxation_time_ensemble_p8_ratio.ps');
    my $img_file_name  = $img_dir->file('relaxation_time_ensemble_p8_ratio.png');
    my $dat_file = IO::File->new($dat_file_name, 'w');
    my $plt_file = IO::File->new($plt_file_name, 'w');
    for my $dls_trial (@dls_trial) {
        $dls_trial->date eq '2009-01-29' and next;
        my $p8_ratio = $dls_trial->p8_ratio;
        if (!defined $old_p8_ratio or $old_p8_ratio != $p8_ratio) {
            $out .= "\n\n" if defined $old_p8_ratio;
            $out .= sprintf "# %s%% P8\n", $p8_ratio;
            $index++;
            push @plot, sprintf qq{'%s' ind %s t '%s%% P8'}, $dat_file_name, $index, $p8_ratio;
        }
        my $relaxation_time = $dls_trial->relaxation_time or next;
        my $count_rate_max = $dls_trial->count_rate_max or next;
        $out .= sprintf "%s\t%s\n", $count_rate_max, $relaxation_time;
        $old_p8_ratio = $p8_ratio;
    }
    $plot = join ',', @plot;
    $dat_file->print($out);
    $dat_file->close;
    $dat_file->close;
    $out = qq{
set term postscript
set key outside
set size 1.5,1
set xlabel 'Count Rate Max'
set ylabel 'Relaxation Time[ms]'
set xrange[3:2000]
set yrange[0.01:1]
set logscale x
set logscale y
set output '$ps_file_name'
plot $plot
        };
    $plt_file->print($out);
    Q10::Gnuplot->run($plt_file_name);
    Q10::Gnuplot->convert($ps_file_name, $img_file_name);
}
