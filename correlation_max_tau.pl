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
    my $html_file_name = html_dir->file('correlation_max_tau.html');
    my $html_file = IO::File->new($html_file_name, 'w');
    my $html = '';
    my $divider1 = Q10::Divider->new;
    $divider1->size       = {x => 1.5};
    $divider1->divider    = 'sample_angle';
    $divider1->key        = 'p8_ratio';
    $divider1->x          = 'correlation_max';
    $divider1->y          = 'relaxation_time';
    $divider1->logscale   = {x => 1,y => 1};
    $divider1->range      = {x => [0.001, 2]};
    $divider1->run;
    $html .= $divider1->get_html;
    $html_file->print($html);
    $html_file->close;
}
