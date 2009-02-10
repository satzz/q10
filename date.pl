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

my @dls_trial = moco('DLSTrial')->search(where => 'cell_id = 2 and temperture > 1100', order => 'date asc');
my $dat_file_name = $dat_dir->file('date.dat');
my $plt_file_name = $plt_dir->file('date.plt');
my $ps_file_name  = $ps_dir->file('date.ps');
my $img_file_name  = $img_dir->file('date.png');
my $dat_file = IO::File->new($dat_file_name, 'w');
my $plt_file = IO::File->new($plt_file_name, 'w');

my $index = -1;
my @plot;
my $plot;
my $out;
my ($old_date, $date);

for my $dls_trial (@dls_trial) {
    my $p8_ratio = $dls_trial->p8_ratio;
    my $date =$dls_trial->date;
    if (!defined $old_date or $old_date ne $date) {
        $out .= "\n\n" if defined $old_date;
        $out .= sprintf "# %s\n", $date;
        $index++;
        push @plot, sprintf qq{'%s' ind %s t '%s'}, $dat_file_name, $index, $date;
    }
    my $relaxation_time = $dls_trial->relaxation_time or next;
    my $k = $dls_trial->k or next;
    $out .= sprintf "%s\t%s\n", $k, 1/$relaxation_time if $relaxation_time > 0;
    $old_date = $date;
}
$plot = join ',', @plot;
$dat_file->print($out);
$dat_file->close;
$dat_file->close;
$out = qq{
set term postscript
set key outside
set size 1.5,1
set xlabel 'k[/nm]'
set ylabel '1/Relaxation Time[1/ms]'
set xrange[0.004:0.01]
set yrange[0.1:50]
set logscale x
set logscale y
set output '$ps_file_name'
plot $plot
};
$plt_file->print($out);
Q10::Gnuplot->run($plt_file_name);
Q10::Gnuplot->convert($ps_file_name, $img_file_name);
