package Q10::Config;
use strict;
use warnings;
use lib qw{./lib};
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;

use UNIVERSAL::require;
use Exporter::Lite;

our @EXPORT = qw/dat_dir plt_dir ps_dir img_dir html_dir/;

sub dat_dir  {dir($Bin, qw/ graph dat /)};
sub plt_dir  {dir($Bin, qw/ graph plt /)};
sub ps_dir   {dir($Bin, qw/ graph ps /)};
sub img_dir  {dir($Bin, qw/ graph img /)};
sub html_dir {dir($Bin, qw/ html /)};

