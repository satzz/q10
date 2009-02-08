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
my $param_dir = dir($Bin, qw/ graph param /);
my $log_dir = dir($Bin, qw/ graph log /);

moco('TempertureP8Ratio')->retrieve_all()->each(sub {$_->delete});
my @temperture = map {$_->temperture} moco('DLSTrial')->search(field => 'distinct temperture');
for my $temperture (@temperture) {
    warn $temperture;
    my $dat_file_name = $dat_dir->file(sprintf 'temperture_%s.dat', $temperture);
    my $dat_file = IO::File->new($dat_file_name, 'r');
    my @line = grep {/\% P8/} <$dat_file>;
    my @p8_ratio;
    for my $line (@line) {
        my ($p8_ratio) = $line =~ /(.+)\%/;
        push @p8_ratio, $p8_ratio;
    }
    my $ind = 0;
    for my $p8_ratio (@p8_ratio) {
        my $log_file_name = $log_dir->file(sprintf 'temperture_p8_ratio_%s_%s.txt', $temperture, $p8_ratio);
        my $param_file_name = $param_dir->file(sprintf 'temperture_p8_ratio_%s_%s.txt', $temperture, $p8_ratio);
        my $fit_file_name = $plt_dir->file(sprintf 'temperture_p8_ratio_%s_%s.plt', $temperture, $p8_ratio);
        my $res = Q10::Gnuplot->get_param(
            fit_file_name   => $fit_file_name,
            log_file_name   => $log_file_name,
            statement       => qq{
fit a * x ^ b '$dat_file_name' ind $ind via a, b
},
            param_file_name => $param_file_name,
            param           => [qw/a b/],
        );
        my $record = moco('TempertureP8Ratio')->create(
            temperture => $temperture,
            p8_ratio   => $p8_ratio,
            a          => $res->{a},
            b          => $res->{b}
        );
        $ind++;
    }
}
