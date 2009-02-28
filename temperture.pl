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
    $divider1->y_avg      = 1;
    $divider1->with_lines = 1;
    $divider1->logscale   = {x => 1, y => 1};
    $divider1->range      = {x => [0.004, 0.01], y => [1, 200]};
    $divider1->where      = qq{relaxation_time > 0.005 AND date NOT IN ('2009-01-26', '2009-01-27', '2009-01-28', '2009-01-29', '2009-02-10', '2009-02-17')};
#     $divider1->where      = qq{relaxation_time > 0.005 AND date IN ('2009-02-26')};
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
    $divider1->where      = qq{relaxation_time > 0.005 AND date NOT IN ('2009-01-26', '2009-01-27', '2009-01-28', '2009-01-29', '2009-02-10', '2009-02-17')};
    $divider1->run;
}



