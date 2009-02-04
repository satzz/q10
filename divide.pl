use strict;
use warnings;
use lib qw{./lib};
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;
use Q10::MoCo;
use Q10::Gnuplot;
{
    my $chunk = {};
    for my $dls_trial (moco('DLSTrial')->retrieve_all) {
        $dls_trial->date eq '2009-01-29' or next;
        my $temperture = $dls_trial->temperture;
        my $p8_ratio = $dls_trial->p8_ratio;
        $chunk->{$temperture} ||= {};
        $chunk->{$temperture}->{$p8_ratio} ||= [];
        push @{$chunk->{$temperture}->{$p8_ratio}}, $dls_trial;
    }

    for my $temperture (sort {$a <=> $b} keys %$chunk) {
        my $small_chunk = $chunk->{$temperture};
        my $out = '';
        for my $p8_ratio (sort {$a <=> $b} keys %$small_chunk) {
            for (sort {$a->[0] <=> $b->[0]} map {[$_->k, $_]} @{$small_chunk->{p8_ratio}}) {
                my $k = $_->[0];
                my $dsl_trial = $_->[1];
                my $relaxation_time = $dls_trial->relaxation_time;
                $out .= sprintf "%s\t%s\n", $k, 1/$relaxation_time;
            }
            $out .= "\n";
        }
        my $dat_file_name = $dat_dir->file(sprintf 'temperture_%s.dat', $temperture);
        my $plt_file_name = $plt_dir->file(sprintf 'temperture_%s.plt', $temperture);
        my $ps_file_name  = $ps_dir->file(sprintf 'temperture_%s.ps', $temperture);
        my $dat_file = IO::File->new($dat_file_name, 'w');
        my $plt_file = IO::File->new($plt_file_name, 'w');
        my $ps_file = IO::File->new($ps_file_name, 'w');
        $dat_file->print($out);
        $dat_file->close;
        $dat_file->close;
        $out = qq{
set term postscript
set output $ps_file
        };
        
    }
}

