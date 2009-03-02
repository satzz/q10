use strict;
use warnings;
use lib qw{./lib};
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;
use Q10::MoCo;
use Q10::Config;
use Q10::Gnuplot;
use Q10::Parser;

my $graph_html;
my @dls_trial = moco('DLSTrial')->search(where => 'relaxation_time > 0');
for my $dls_trial (@dls_trial) {
    $dls_trial->date eq '2009-03-02' or next;
#     $dls_trial->cell_id == 17 or next;
    my $y = $dls_trial->y;
    my $a = $dls_trial->a;
    my $tau = $dls_trial->relaxation_time or next;
    my $beta = $dls_trial->beta;
    my $dls_trial_id = $dls_trial->dls_trial_id;
    warn $dls_trial_id;
    my $correlation_ps_file_name  = ps_dir->file(sprintf 'correlation_dls_%s.ps', $dls_trial_id);
    my $correlation_plt_file_name = plt_dir->file(sprintf 'correlation_dls_%s.plt', $dls_trial_id);
    my $correlation_dat_file_name = dat_dir->file(sprintf 'correlation_dls_%s.dat', $dls_trial_id);
    my $correlation_img_file_name = img_dir->file(sprintf 'correlation_dls_%s.png', $dls_trial_id);
    my $correlation_plt_file      = IO::File->new($correlation_plt_file_name, 'w');
    my $correlation_max = $dls_trial->correlation_max;
    my $correlation_title = '';
    $correlation_plt_file->print (<<EOD);
set term postscript
set yrange[0:$correlation_max]
set xlabel 'Time[ms]'
set ylabel 'Correlation'
set logscale x
set key outside
set output '$correlation_ps_file_name'
plot '$correlation_dat_file_name' t '$correlation_title', $y + $a * exp(-(x / $tau) ** $beta) t 'fit'
EOD
    Q10::Gnuplot->run($correlation_plt_file_name);
    Q10::Gnuplot->convert($correlation_ps_file_name, $correlation_img_file_name);
    warn $correlation_img_file_name;

    my $count_rate_ps_file_name  = ps_dir->file(sprintf 'count_rate_dls_%s.ps', $dls_trial_id);
    my $count_rate_plt_file_name = plt_dir->file(sprintf 'count_rate_dls_%s.plt', $dls_trial_id);
    my $count_rate_dat_file_name = dat_dir->file(sprintf 'count_rate_dls_%s.dat', $dls_trial_id);
    my $count_rate_img_file_name = img_dir->file(sprintf 'count_rate_dls_%s.png', $dls_trial_id);
    my $count_rate_plt_file      = IO::File->new($count_rate_plt_file_name, 'w');
    my $count_rate_max = $dls_trial->count_rate_max;
    my $count_rate_min = $dls_trial->count_rate_min;
    my $count_rate_title = '';
    $count_rate_plt_file->print (<<EOD);
set term postscript
set yrange[0:30]
set yrange[$count_rate_min:$count_rate_max]
set xlabel 'Time[s]'
set ylabel 'Count Rate'
set key outside
set output '$count_rate_ps_file_name'
plot '$count_rate_dat_file_name' t '$count_rate_title' w l
EOD
    Q10::Gnuplot->run($count_rate_plt_file_name);
    Q10::Gnuplot->convert($count_rate_ps_file_name, $count_rate_img_file_name);
    warn $count_rate_img_file_name;
}





