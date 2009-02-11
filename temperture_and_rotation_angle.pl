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

my $html_file_name = html_dir->file('index.html');
my $html_file = IO::File->new($html_file_name, 'w');
my $html = '';

my $divider1 = Q10::Divider->new;
$divider1->divider = 'temperture';
$divider1->key      = 'p8_ratio';
$divider1->x        = 'rotation_angle';
$divider1->y        = 'relaxation_time inverse';
$divider1->logscale = {x => 1, y => 1};
$divider1->range    = {x => [0.004, 0.01]};
$divider1->run;
$html .= $divider1->get_html;

my $divider2 = Q10::Divider->new;
$divider2->divider = 'rotation_angle';
$divider2->key      = 'p8_ratio';
$divider2->x        = 'temperture';
$divider2->y        = 'relaxation_time inverse';
$divider2->logscale = {y => 1};
$divider2->range    = {x => [60, 160], y => [0.01, 100]};
$divider2->run;
$html .= $divider2->get_html;

$html_file->print($html);
$html_file->close;




