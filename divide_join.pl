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
my $html_dir = dir($Bin, qw/ html /);
my $html_file_name = $html_dir->file('index.html');
my $html_file = IO::File->new($html_file_name, 'w');
my $html = '';

{
    my @temperture = map {$_->temperture} moco('DLSTrial')->search(field => 'distinct temperture', order => 'temperture desc');
    for my $temperture (@temperture) {
        my $dat_file_name = $dat_dir->file(sprintf 'temperture_%s.dat', $temperture);
        my $plt_file_name = $plt_dir->file(sprintf 'temperture_%s.plt', $temperture);
        my $ps_file_name  = $ps_dir->file(sprintf 'temperture_%s.ps', $temperture);
        my $img_file_name  = $img_dir->file(sprintf 'temperture_%s.png', $temperture);
        my $dat_file = IO::File->new($dat_file_name, 'w');
        my $plt_file = IO::File->new($plt_file_name, 'w');
        my @dls_trial = moco('DLSTrialCellSample')->search(
            where => {temperture => $temperture},
            order => 'p8_ratio ASC, rotation_angle ASC',
        );
        my ($old_p8_ratio, $p8_ratio);
        my $index = -1;
        my @plot;
        my $plot;
        my $out;
        for my $dls_trial (@dls_trial) {
            $p8_ratio = $dls_trial->p8_ratio;
            if (!defined $old_p8_ratio or $old_p8_ratio != $p8_ratio) {
                $out .= sprintf "# %s%% P8\n", $p8_ratio;
                $index++;
                push @plot, sprintf qq{'%s' ind %s t '%s%% P8'}, $dat_file_name, $index, $p8_ratio;
                $out .= "\n\n";
            }
            my $k = $dls_trial->k;
            my $relaxation_time = $dls_trial->relaxation_time or next;
            $out .= sprintf "%s\t%s\n", $k, 1/$relaxation_time;
            $old_p8_ratio = $p8_ratio;
        }
        $plot = join ',', @plot;
        $dat_file->print($out);
        $dat_file->close;
        $dat_file->close;
        $out = qq{
set term postscript
set key outside
set xlabel 'k[/nm]'
set ylabel '1/relaxation time[/ms]'
set xrange [0.004:0.01]
set logscale x
set logscale y
set output '$ps_file_name'
plot $plot
        };
        $plt_file->print($out);
        Q10::Gnuplot->run($plt_file_name);
        Q10::Gnuplot->convert($ps_file_name, $img_file_name);
        $html .= sprintf qq{<h3>temperture: %s deg C</h3><img src="%s" />}, $temperture/10, $img_file_name;
    }
}
$html_file->print($html);
$html_file->close;




