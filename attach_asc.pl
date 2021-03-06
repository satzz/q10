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

# moco('DLSTrial')->retrieve_all->each(sub {$_->delete});
# unlink dat_dir->file($_) for grep {/dat/} dat_dir->open->read;
# unlink plt_dir->file($_) for grep {/plt/} plt_dir->open->read;
# unlink ps_dir->file($_) for grep {/ps/} ps_dir->open->read;
# unlink param_dir->file($_) for grep {/txt/} param_dir->open->read;
# unlink log_dir->file($_) for grep {/txt/} log_dir->open->read;
# my $graph_html;
for my $date (sort grep {/\d+/} asc_dir->open->read) {
    $date eq '090302' or next;
    my ($year, $month, $day) = $date =~ /^(\d{2})(\d{2})(\d{2})$/;
    $day or next;
    my $date_dir = asc_dir->subdir($date);
    for my $asc_file_name (sort grep {/ASC/} $date_dir->open->read) {
        warn sprintf '%s', $date_dir->file($asc_file_name);
        my $asc = $date_dir->file($asc_file_name);
        my ($cell_id, $rotation_angle, $sample_angle, $laser_position, $nd_filter_position, $polarizer_angle, $sample_position, $temperture) =
            $asc_file_name =~ /cell(\d+)_(\d+)_(\d+)_(\d+)_(\d+)_(\d+)_(\d+)_(\d+)[.]ASC/;
#         $cell_id == 17 or next;
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
            my ($time, $val) = $line =~ /([.\dE\-\+]+)\s+([.\dE\-\+]+)/;
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
        my $date_val = (sprintf '20%s-%s-%s', $year, $month, $day);
        my $dls_trial = moco('DLSTrial')->search(
            where => {
                cell_id             => $cell_id,
                date                => $date_val,
                temperture          => $temperture,
                rotation_angle      => $rotation_angle,
                sample_angle        => $sample_angle,
                laser_position      => $laser_position,
                nd_filter_position  => $nd_filter_position,
                polarizer_angle     => $polarizer_angle,
                sample_position     => $sample_position,
            }
        )->first;
#         $dls_trial->relaxation_time > 0.2 or next;
        $dls_trial or $dls_trial = moco('DLSTrial')->create(
            cell_id             => $cell_id,
            date                => $date_val,
            temperture          => $temperture,
            rotation_angle      => $rotation_angle,
            sample_angle        => $sample_angle,
            laser_position      => $laser_position,
            nd_filter_position  => $nd_filter_position,
            polarizer_angle     => $polarizer_angle,
            sample_position     => $sample_position,
            count_rate_min      => $count_rate_min,
            count_rate_max      => $count_rate_max,
            correlation_max     => $correlation_max,
        );
        my $dls_trial_id = $dls_trial->dls_trial_id;
        my $correlation_dat_file_name = dat_dir->file(sprintf 'correlation_dls_%s.dat', $dls_trial_id);
        my $count_rate_dat_file_name  = dat_dir->file(sprintf 'count_rate_dls_%s.dat', $dls_trial_id);
#         my $correlation_plt_file_name = plt_dir->file(sprintf 'correlation_dls_%s.plt', $dls_trial_id);
#         my $count_rate_plt_file_name  = plt_dir->file(sprintf 'count_rate_dls_%s.plt', $dls_trial_id);
        my $correlation_ps_file_name  = ps_dir->file(sprintf 'correlation_dls_%s.ps', $dls_trial_id);
        my $count_rate_ps_file_name   = ps_dir->file(sprintf 'count_rate_dls_%s.ps', $dls_trial_id);
        my $correlation_img_file_name = img_dir->file(sprintf 'correlation_dls_%s.png', $dls_trial_id);
        my $count_rate_img_file_name  = img_dir->file(sprintf 'count_rate_dls_%s.png', $dls_trial_id);
        my $param_file_name           = param_dir->file(sprintf 'count_rate_param_%s.txt', $dls_trial_id);
        my $fit_file_name             = plt_dir->file(sprintf 'fit_dls_%s.plt', $dls_trial_id);
        my $log_file_name             = log_dir->file(sprintf 'fit_log_%s.txt', $dls_trial_id);
        my $correlation_dat_file      = IO::File->new($correlation_dat_file_name, 'w');
        my $count_rate_dat_file       = IO::File->new($count_rate_dat_file_name, 'w');
#         my $correlation_plt_file      = IO::File->new($correlation_plt_file_name, 'w');
#         my $count_rate_plt_file       = IO::File->new($count_rate_plt_file_name, 'w');
        $correlation_dat_file->print (join '', @correlation);
        $count_rate_dat_file->print (join '', @count_rate);
        $correlation_dat_file->close;
        $count_rate_dat_file->close;

#         my $count_rate_max = $dls_trial->count_rate_max;
        my $correlation_title = '';
        my $count_rate_title = '';
        my $res = Q10::Gnuplot->get_param(
            fit_file_name   => $fit_file_name,
            log_file_name   => $log_file_name,
            statement       => qq{
set xrange [0.01:1]
tau = 0.1
beta = 1
A = $correlation_max
fit y_0 + A * exp(-(x/tau)** beta) '$correlation_dat_file_name' via y_0, A, tau, beta
},
            param_file_name => $param_file_name,
        ) or next;
        my $tau = $res->{tau};
        my $a = $res->{A};
        my $beta = $res->{beta};
        my $y = $res->{y_0};
        my $fit_wssr = $res->{FIT_WSSR};
        my $fit_stdfit = $res->{FIT_STDFIT};
        $dls_trial->relaxation_time($tau);
        $dls_trial->a($a);
        $dls_trial->beta($beta);
        $dls_trial->y($y);
        $dls_trial->fit_wssr($fit_wssr);
        $dls_trial->fit_stdfit($fit_stdfit);
    }
}








