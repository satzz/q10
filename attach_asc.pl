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
moco('DLSTrial')->retrieve_all->each(sub {$_->delete});
unlink $dat_dir->file($_) for grep {/dat/} $dat_dir->open->read;
unlink $plt_dir->file($_) for grep {/plt/} $plt_dir->open->read;
unlink $ps_dir->file($_) for grep {/ps/} $ps_dir->open->read;
unlink $param_dir->file($_) for grep {/txt/} $param_dir->open->read;
my $asc_dir = dir($Bin, qw/ DLS  asc /);
my $graph_html;
for my $date (sort grep {/\d+/} $asc_dir->open->read) {
    my ($year, $month, $day) = $date =~ /^(\d{2})(\d{2})(\d{2})$/;
    $day or next;
    my $date_dir = $asc_dir->subdir($date);
    for my $asc_file_name (sort grep {/ASC/} $date_dir->open->read) {
        warn sprintf '%s', $date_dir->file($asc_file_name);
        my $asc = $date_dir->file($asc_file_name);
        my ($cell_id, $rotation_angle, $sample_angle, $laser_position, $nd_filter_position, $polarizer_angle, $sample_position, $temperture) =
            $asc_file_name =~ /cell(\d+)_(\d+)_(\d+)_(\d+)_(\d+)_(\d+)_(\d+)_(\d+)[.]ASC/;
        my $io = IO::File->new($asc);
        my $flag = 0;
        my @correlation, my @count_rate;
        my $count_rate_max = 0;
        my $count_rate_min = 4000;
        my $correlation_max = 0;
        my $line_index = 0;
        while (my $line = <$io>) {
            $line_index++;
            chomp $line;
            if ($line =~ /Correlation/) {
                $flag = 1;
                next;
            } elsif ($line =~ /Count Rate/) {
                $flag = 3;
                next;
            }
            my ($time, $val) = $line =~ /([.\dE\-]+)\s+([.\dE\-]+)/;
            if ($flag == 1) {
                if (defined $time) {
                    push @correlation, sprintf "%s\t%s\n", $time, $val;
                    $correlation_max = $val if $correlation_max < $val;
                } else {
                    $flag = 2;
                }
            } elsif ($flag == 3) {
                defined $time or last;
                push @count_rate, sprintf "%s\t%s\n", $time, $val;
                $count_rate_max = $val if $count_rate_max < $val;
                $count_rate_min = $val if $count_rate_min > $val;
            }
        }
        my $dls_trial = moco('DLSTrial')->create(
            cell_id             => $cell_id,
            date                => (sprintf '20%s-%s-%s', $year, $month, $day),
            temperture          => $temperture,
            sample_angle        => $sample_angle,
            laser_position      => $laser_position,
            nd_filter_position  => $nd_filter_position,
            polarizer_angle     => $polarizer_angle,
            sample_position     => $sample_position,
            count_rate_min      => $count_rate_min,
            count_rate_max      => $count_rate_max,
        );
        my $dls_trial_id = $dls_trial->dls_trial_id;
        my $correlation_dat_file_name = $dat_dir->file(sprintf 'correlation_dls_%s.dat', $dls_trial_id);
        my $count_rate_dat_file_name  = $dat_dir->file(sprintf 'count_rate_dls_%s.dat', $dls_trial_id);
        my $correlation_plt_file_name = $plt_dir->file(sprintf 'correlation_dls_%s.plt', $dls_trial_id);
        my $count_rate_plt_file_name  = $plt_dir->file(sprintf 'count_rate_dls_%s.plt', $dls_trial_id);
        my $correlation_ps_file_name  = $ps_dir->file(sprintf 'correlation_dls_%s.ps', $dls_trial_id);
        my $count_rate_ps_file_name   = $ps_dir->file(sprintf 'count_rate_dls_%s.ps', $dls_trial_id);
        my $correlation_img_file_name = $img_dir->file(sprintf 'correlation_dls_%s.png', $dls_trial_id);
        my $count_rate_img_file_name  = $img_dir->file(sprintf 'count_rate_dls_%s.png', $dls_trial_id);
        my $param_file_name           = $param_dir->file(sprintf 'count_rate_param_%s.txt', $dls_trial_id);
        my $fit_file_name             = $plt_dir->file(sprintf 'fit_dls_%s.plt', $dls_trial_id);
        my $correlation_dat_file      = IO::File->new($correlation_dat_file_name, 'w');
        my $count_rate_dat_file       = IO::File->new($count_rate_dat_file_name, 'w');
        my $correlation_plt_file      = IO::File->new($correlation_plt_file_name, 'w');
        my $count_rate_plt_file       = IO::File->new($count_rate_plt_file_name, 'w');
        $correlation_dat_file->print (join '', @correlation);
        $count_rate_dat_file->print (join '', @count_rate);

        my $correlation_title = '';
        my $count_rate_title = '';
        my $tau = Q10::Gnuplot->get_param(
            fit_file_name   => $fit_file_name,
            target          => qq{fit y_0 + A * exp((x/tau)** b) '$correlation_dat_file_name' via y_0, A, tau, b},
            param_file_name => $param_file_name,
            param           => 'tau',
        );
        $dls_trial->relaxation_time($tau);
        $correlation_plt_file->print (<<EOD);
set term postscript
set yrange[0:$correlation_max]
set logscale x
set key outside
set output '$correlation_ps_file_name'
plot '$correlation_dat_file_name' t '$correlation_title'
EOD
        $count_rate_plt_file->print (<<EOD);
set term postscript
set key outside
set output '$count_rate_ps_file_name'
plot '$count_rate_dat_file_name' w l t '$count_rate_title'
EOD
        $correlation_dat_file->close;
        $count_rate_dat_file->close;
        $correlation_plt_file->close;
        $count_rate_plt_file->close;
        Q10::Gnuplot->run($correlation_plt_file_name);
        Q10::Gnuplot->convert($correlation_ps_file_name, $correlation_img_file_name);
        Q10::Gnuplot->run($count_rate_plt_file_name);
        Q10::Gnuplot->convert($count_rate_ps_file_name, $count_rate_img_file_name);
        $graph_html .= sprintf qq{
<h3>%s : </h3>
<img src="%s" width=600 height=400 />
<img src="%s" width=600 height=400 />
\n}, $dls_trial_id, $correlation_img_file_name, $count_rate_img_file_name;
        last;
    }
}

my $graph_html_file = IO::File->new(dir($Bin, 'html')->file('dls.html'), 'w');
$graph_html_file->print($graph_html);
$graph_html_file->close;






