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

my $dat_file_name    = dat_dir->file('coeff.dat');
my $dat_ln_file_name = dat_dir->file('coeff.dat');
my $plt_file_name    = plt_dir->file('coeff.plt');
my $ps_file_name     = ps_dir->file('coeff.ps');
my $img_file_name    = img_dir->file('coeff.png');
my $dat_file = IO::File->new($dat_file_name, 'w');
my $dat_ln_file = IO::File->new($dat_ln_file_name, 'w');
my $plt_file = IO::File->new($plt_file_name, 'w');

my @record = moco('TempertureP8Ratio')->search(order => 'p8_ratio asc, temperture asc');
my ($old_p8_ratio, $p8_ratio);
my $index = -1;
my @plot;
my $plot;
my $out;
for my $record (@record) {
    $p8_ratio = $record->p8_ratio;
    warn $p8_ratio;
    if (!defined $old_p8_ratio or $old_p8_ratio != $p8_ratio) {
        $out .= "\n\n" if defined $old_p8_ratio;
        $out .= sprintf "# %s%% P8\n", $p8_ratio;
        $index++;
        push @plot, sprintf qq{'%s' ind %s  w l t '%s%% P8'}, $dat_file_name, $index, $p8_ratio;
    }
    my $temperture = $record->temperture;
    my $b = $record->b;
    $out .= sprintf "%s\t%s\n", $temperture, $b;
    $old_p8_ratio = $p8_ratio;
}
$plot = join ',', @plot;
$dat_file->print($out);
$dat_file->close;
$dat_file->close;
$out = qq{
set term postscript
set key outside
set xlabel 'temperture[deg C]'
set ylabel 'b'
set xrange [600:1600]

set output '$ps_file_name'
plot $plot
};
$plt_file->print($out);
Q10::Gnuplot->run($plt_file_name);
Q10::Gnuplot->convert($ps_file_name, $img_file_name);





