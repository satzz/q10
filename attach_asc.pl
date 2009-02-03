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
moco('DLSTrial')->retrieve_all->each(sub {$_->delete});
my @dat_file = grep {/dat/} $dat_dir->open->read;
my @plt_file = grep {/plt/} $plt_dir->open->read;
my @ps_file = grep {/ps/} $ps_dir->open->read;
my @img_file = $img_dir->open->read;
system qq{cd $dat_dir; rm $_} for @dat_file;
system qq{cd $plt_dir; rm $_} for @plt_file;
system qq{cd $ps_dir; rm $_} for @ps_file;
my $asc_dir = dir($Bin, qw/ DLS  asc /);
for my $date (sort grep {/\d+/} $asc_dir->open->read) {
    my ($year, $month, $day) = $date =~ /^(\d{2})(\d{2})(\d{2})$/;
    $day or next;
    my $date_dir = $asc_dir->subdir($date);
    for my $asc_file_name (sort grep {/ASC/} $date_dir->open->read) {
        my $asc = $date_dir->file($asc_file_name);
        warn $asc_file_name;
        my ($cell_id, $rotation_angle, $sample_angle, $laser_position, $nd_filter_position, $polarizer_angle, $sample_position, $temperture) =
            $asc_file_name =~ /cell(\d+)_(\d+)_(\d+)_(\d+)_(\d+)_(\d+)_(\d+)_(\d+)[.]ASC/;
        my $io = IO::File->new($asc);
        my $flag = 0;
        my @correlation, my @count_rate;
        my $count_rate_max = 0;
        my $count_rate_min = 4000;
        while (my $line = <$io>) {
            chomp $line;
            if ($line =~ /Correlation/) {
                $flag = 1;
                next;
            } elsif ($line =~ /Count Rate/) {
                $flag = 3;
                next;
            }
#             warn $line;
            my ($time, $val) = grep {defined $_} split /\s+/, $line;
            if ($flag == 1) {
                $time or $flag = 2;
                push @correlation, sprintf "%s\t%s\n", $time, $val;
            } elsif ($flag == 3) {
                $time or last;
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
        my $count_rate_dat_file_name = $dat_dir->file(sprintf 'count_rate_dls_%s.dat', $dls_trial_id);
        my $correlation_dat_file = IO::File->new($correlation_dat_file_name, 'w');
        my $count_rate_dat_file  = IO::File->new($count_rate_dat_file_name, 'w');
        my $correlation_plt_file = IO::File->new($plt_dir->file(sprintf 'correlation_dls_%s.plt', $dls_trial_id), 'w');
        my $count_rate_plt_file  = IO::File->new($plt_dir->file(sprintf 'count_rate_dls_%s.plt', $dls_trial_id), 'w');
        $correlation_dat_file->print (join '', @correlation);
        $count_rate_dat_file->print (join '', @count_rate);
        my $correlation_ps_file_name =  $ps_dir->file(sprintf 'correlation_dls_%s.ps', $dls_trial_id);
        my $count_rate_ps_file_name =  $ps_dir->file(sprintf 'count_rate_dls_%s.ps', $dls_trial_id);
        $correlation_plt_file->print (<<EOD);
set term postscript
set output '$correlation_ps_file_name'
plot '$correlation_dat_file_name'
EOD
        $count_rate_plt_file->print (<<EOD);
set term postscript
set output '$count_rate_ps_file_name'
plot '$count_rate_dat_file_name'
EOD
        $correlation_dat_file->close;
        $count_rate_dat_file->close;
        $correlation_plt_file->close;
        $count_rate_plt_file->close;
        Q10::Gnuplot->run($correlation_dat_file_name);
        Q10::Gnuplot->run($count_rate_dat_file_name);
    }
}




