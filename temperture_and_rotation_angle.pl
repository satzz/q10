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

my $divider1 = Q10::Divider->new(
    divider  => 'temperture',
    key      => 'p8_ratio',
    x        => 'k',
    y        => 'relaxation_time inverse'
    logscale => [qw/x y/],
    xrange   => [0.004, 0.01];
);
$divider1->run;
$html .= $divider1->get_html;

my $divider2 = Q10::Divider->new(
    divider  => 'rotation_angle',
    key      => 'p8_ratio',
    x        => 'temperture',
    y        => 'relaxation_time inverse'
    logscale => [qw/y/],
    xrange   => [60, 160];
    yrange   => [0, 100];
);
$divider2->run;
$html .= $divider2->get_html;

$html_file->print($html);
$html_file->close;




