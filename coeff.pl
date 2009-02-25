use strict;
use warnings;
use lib qw{./lib};
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;
use Q10::MoCo;
use Q10::Config;
use Q10::Divider;
use Q10::Gnuplot;

my $dat_file_name    = dat_dir->file('coeff.dat');
my $dat_ln_file_name = dat_dir->file('coeff.dat');
my $plt_file_name    = plt_dir->file('coeff.plt');
my $ps_file_name     = ps_dir->file('coeff.ps');
my $img_file_name    = img_dir->file('coeff.png');
my $dat_file = IO::File->new($dat_file_name, 'w');
my $dat_ln_file = IO::File->new($dat_ln_file_name, 'w');
my $plt_file = IO::File->new($plt_file_name, 'w');

{
    my $html_file_name = html_dir->file('temperture.html');
    my $html_file = IO::File->new($html_file_name, 'w');
    my $html = '';
    my $divider1 = Q10::Divider->new;
    $divider1->model      = 'TempertureP8Ratio';
    $divider1->divider_model      = 'TempertureP8Ratio';
    $divider1->divider    = 'temp_column';
    $divider1->key        = 'p8_ratio';
    $divider1->x          = 'temperture';
    $divider1->y          = 'b';
    $divider1->with_lines = 1;
    $divider1->run;
    $html .= $divider1->get_html;
    $html_file->print($html);
    $html_file->close;
}







