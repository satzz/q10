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

$html .= divider('Temperture')->get_html;
$html .= divider('RotationAngle')->get_html;

$html_file->print($html);
$html_file->close;




