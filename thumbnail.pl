use strict;
use warnings;
use lib qw{./lib};
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;
use Q10::MoCo;
use Q10::Gnuplot;

use File::Find;

my $img_dir = dir($Bin, qw/ graph img /);
my $tn_dir = dir($Bin, qw/ graph img thumbnail /);
unlink $tn_dir->file($_) for grep {/png/} $tn_dir->open->read;

my $width = 200;
my $height = 150;
for my $file_name (grep {/png/} $img_dir->open->read) {
    system sprintf 'convert -resize %sx%s %s %s', $width, $height, $img_dir->file($file_name), $tn_dir->file($file_name);
    last;
}


