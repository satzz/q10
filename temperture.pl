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
    my $html_file_name = html_dir->file('temperture.html');
    my $html_file = IO::File->new($html_file_name, 'w');
    my $html = '';
    my $divider1 = Q10::Divider->new;
    $divider1->divider    = 'temperture';
    $divider1->key        = 'p8_ratio';
    $divider1->x          = 'rotation_angle';
    $divider1->y          = 'relaxation_time';
    $divider1->y_inv      = 1;
    $divider1->logscale   = {x => 1, y => 1};
    $divider1->range      = {x => [0.004, 0.01]};
    # $divider1->where    = qq{cell_id = 13};
    $divider1->run;
    $html .= $divider1->get_html;
    $html_file->print($html);
    $html_file->close;
}
{
    my $divider1 = Q10::Divider->new;
    $divider1->divider    = 'temperture';
    $divider1->key        = 'p8_ratio';
    $divider1->x          = 'rotation_angle';
    $divider1->y          = 'relaxation_time';
    $divider1->y_inv      = 1;
    $divider1->x_logvalue = 1;
    $divider1->y_logvalue = 1;
    # $divider1->where    = qq{cell_id = 13};
    $divider1->run;
}



