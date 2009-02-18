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

# my $html_file_name = html_dir->file('temperture_p8_ratio.html');
# my $html_file = IO::File->new($html_file_name, 'w');
# my $html = '';

moco('TempertureP8Ratio')->retrieve_all->each(sub {$_->delete});
my @temperture = map {$_->temperture} moco('DLSTrial')->search(field => 'distinct temperture');
for my $temperture (@temperture) {
    warn $temperture;

    my $dat_file_name = dat_dir->file(sprintf 'temperture_p8_ratio_rotation_angle_relaxation_time_%s.dat', $temperture);
    my $dat_ln_file_name = dat_dir->file(sprintf 'temperture_p8_ratio_rotation_angle_relaxation_time_%s_x_logvalue_y_logvalue.dat', $temperture);
    my $dat_file = IO::File->new($dat_file_name, 'r');
    warn $dat_file_name;
    my @line = grep {/\% P8/} <$dat_file>;
    my @p8_ratio;
    for my $line (@line) {
        my ($p8_ratio) = $line =~ /([\d.]+)\%/;
        push @p8_ratio, $p8_ratio;
    }
    my $ind = 0;
    for my $p8_ratio (@p8_ratio) {
        warn $p8_ratio;
        my $log_file_name = log_dir->file(sprintf 'temperture_p8_ratio_%s_%s.txt', $temperture, $p8_ratio);
        my $param_file_name = param_dir->file(sprintf 'temperture_p8_ratio_%s_%s.txt', $temperture, $p8_ratio);
        my $fit_file_name = plt_dir->file(sprintf 'temperture_p8_ratio_%s_%s.plt', $temperture, $p8_ratio);
        my $res = Q10::Gnuplot->get_param(
            fit_file_name   => $fit_file_name,
            log_file_name   => $log_file_name,
            statement       => qq{fit a + x * b '$dat_ln_file_name' ind $ind via a, b \n},
            param_file_name => $param_file_name,
        );
        my $a = $res->{a} or next;
        my $b = $res->{b} or next;
        my $record = moco('TempertureP8Ratio')->create(
            temperture => $temperture,
            p8_ratio   => $p8_ratio,
            a          => $a,
            b          => $b,
        );
        $ind++;
    }
}


# {
#     my $divider1 = Q10::Divider->new;
#     $divider1->divider    = '';
#     $divider1->key        = 'p8_ratio';
#     $divider1->x          = 'rotation_angle';
#     $divider1->y          = 'relaxation_time';
#     $divider1->y_inv      = 1;
# #     $divider1->y_logvalue = 1;
#     $divider1->logscale   = {x => 1, y => 1};
#     $divider1->range      = {x => [0.004, 0.01]};
#     # $divider1->where    = qq{cell_id = 13};
#     $divider1->run;
#     $html .= $divider1->get_html;
#     $html_file->print($html);
#     $html_file->close;
# }

# # $html_file->print($divider1->get_html);

# my $dat_file_name = dat_dir->file('coeff.dat');
# my $dat_ln_file_name = dat_dir->file('coeff.dat');
# my $plt_file_name = plt_dir->file('coeff.plt');
# my $ps_file_name  = ps_dir->file('coeff.ps');
# my $img_file_name  = img_dir->file('coeff.png');
# my $dat_file = IO::File->new($dat_file_name, 'w');
# my $dat_ln_file = IO::File->new($dat_ln_file_name, 'w');
# my $plt_file = IO::File->new($plt_file_name, 'w');

# my @record = moco('TempertureP8Ratio')->search(order => 'p8_ratio asc, temperture asc');
# my ($old_p8_ratio, $p8_ratio);
# my $index = -1;
# my @plot;
# my $plot;
# my $out;
# for my $record (@record) {
#     $p8_ratio = $record->p8_ratio;
#     if (!defined $old_p8_ratio or $old_p8_ratio != $p8_ratio) {
#         $out .= "\n\n" if defined $old_p8_ratio;
#         $out .= sprintf "# %s%% P8\n", $p8_ratio;
#         $index++;
#         push @plot, sprintf qq{'%s' ind %s t '%s%% P8' w l}, $dat_file_name, $index, $p8_ratio;
#     }
#     my $temperture = $record->temperture;
#     my $b = $record->b;
#     $out .= sprintf "%s\t%s\n", $temperture, $b;
#     $old_p8_ratio = $p8_ratio;
# }
# $plot = join ',', @plot;
# $dat_file->print($out);
# $dat_file->close;
# $dat_file->close;
# $out = qq{
# set term postscript
# set key outside
# set xlabel 'temperture[deg C]'
# set ylabel 'b'
# set xrange [600:1600]

# set output '$ps_file_name'
# plot $plot
# };
# $plt_file->print($out);
# Q10::Gnuplot->run($plt_file_name);
# Q10::Gnuplot->convert($ps_file_name, $img_file_name);





