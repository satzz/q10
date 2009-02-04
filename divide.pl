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
{
    my $html_file_name = $html_dir->file('index.html');
    my $html_file = IO::File->new($html_file_name, 'w');
    my $html = '';
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
        my $dat_file_name = $dat_dir->file(sprintf 'temperture_%s.dat', $temperture);
        my $plt_file_name = $plt_dir->file(sprintf 'temperture_%s.plt', $temperture);
        my $ps_file_name  = $ps_dir->file(sprintf 'temperture_%s.ps', $temperture);
        my $img_file_name  = $img_dir->file(sprintf 'temperture_%s.png', $temperture);
        my $dat_file = IO::File->new($dat_file_name, 'w');
        my $plt_file = IO::File->new($plt_file_name, 'w');
        my @plot;
        my $plot;
        my $index = 0;
        for my $p8_ratio (sort {$a <=> $b} keys %$small_chunk) {
            push @plot, sprintf qq{'%s' ind %s t '%s%% P8'}, $dat_file_name, $index, $p8_ratio;
            for (sort {$a->[0] <=> $b->[0]} map {[$_->k, $_]} @{$small_chunk->{$p8_ratio}}) {
                my $k = $_->[0];
                warn $k;
                my $dls_trial = $_->[1];
                my $relaxation_time = $dls_trial->relaxation_time or next;
                $out .= sprintf "%s\t%s\n", $k, 1/$relaxation_time;
            }
            $out .= "\n";
            $index++;
        }
        $plot = join ',', @plot;
        $dat_file->print($out);
        $dat_file->close;
        $dat_file->close;
        $out = qq{
set term postscript
set key outside
set output '$ps_file_name'
plot $plot
        };
        $plt_file->print($out);
        Q10::Gnuplot->run($plt_file_name);
        Q10::Gnuplot->convert($ps_file_name, $img_file_name);
        $html .= sprintf qq{<h3>temperture: %s</h3><img src="%s" />}, $temperture, $img_file_name;
    }
    $html_file->print($html);
    $html_file->close;
}

