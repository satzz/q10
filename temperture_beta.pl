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
    my $html_file_name = html_dir->file('temperture_beta.html');
    my $html_file = IO::File->new($html_file_name, 'w');
    my $html = '';
    my $divider1 = Q10::Divider->new;
    $divider1->size       = {x => 1.5};
    $divider1->divider    = 'sample_angle';
    $divider1->key        = 'p8_ratio';
    $divider1->x          = 'temperture';
    $divider1->y          = 'beta';
#     $divider1->y_inv      = 1;
    $divider1->logscale   = {y => 1};
    $divider1->range      = {y => [0.1, 3]};
    $divider1->where    = qq{cell_id = 13 or cell_id = 14};
    $divider1->run;
    $html .= $divider1->get_html;
    $html_file->print($html);
    $html_file->close;
}