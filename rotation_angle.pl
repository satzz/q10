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

my $html_file_name = html_dir->file('rotation_angle.html');
my $html_file = IO::File->new($html_file_name, 'w');
my $html = '';
my $divider2 = Q10::Divider->new;
$divider2->divider = 'rotation_angle';
$divider2->key      = 'p8_ratio';
$divider2->x        = 'temperture';
$divider2->y        = 'relaxation_time';
$divider2->y_inv    = 1;
$divider2->logscale = {y => 1};
$divider2->range    = {x => [60, 160], y => [1, 100]};
$divider2->where    = qq{cell_id = 13};
$divider2->run;
$html .= $divider2->get_html;
$html_file->print($html);
$html_file->close;




