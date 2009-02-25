use strict;
use warnings;
use lib qw{./lib};
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;
use Q10::Divider;
use Q10::Config;
use Q10::MoCo;
use Q10::Gnuplot;

my $html_file_name = html_dir->file('date.html');
my $html_file = IO::File->new($html_file_name, 'w');
my $html = '';

my $divider1 = Q10::Divider->new;
$divider1->divider = 'p8_ratio';
$divider1->key      = 'date';
$divider1->x        = 'rotation_angle';
$divider1->y        = 'relaxation_time inverse';
$divider1->logscale = {x => 1, y => 1};
$divider1->size     = {x => 1.5};
$divider1->range    = {x => [0.004, 0.01], y => [2, 40]};
$divider1->run;

$html_file->print($divider1->get_html);
