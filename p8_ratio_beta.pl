use strict;
use warnings;
use lib qw{./lib};
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;
use Q10::MoCo;
use Q10::Divider;
use Q10::Config;
use Q10::Gnuplot;


{
    my $html_file_name = html_dir->file('p8_ratio_beta.html');
    my $html_file = IO::File->new($html_file_name, 'w');
    my $html = '';
    my $divider1 = Q10::Divider->new;
    $divider1->size       = {x => 1.5};
    $divider1->divider    = 'rotation_angle';
    $divider1->key        = 'sample_angle';
    $divider1->x          = 'p8_ratio';
    $divider1->y          = 'beta';
#     $divider1->y_inv      = 1;
    $divider1->logscale   = {y => 1};
#     $divider1->range      = {x => [1, 2000], y => [0.001, 2]};
    $divider1->where    = qq{rotation_angle IN (7000,8000,9000,10000,11000,12000,13000,14000)};
    $divider1->run;
    $html .= $divider1->get_html;
    $html_file->print($html);
    $html_file->close;
}
