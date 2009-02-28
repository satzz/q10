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

our @EXPORT = qw/asc_dir  xls_dir  dat_dir  plt_dir  ps_dir  img_dir  html_dir  param_dir  log_dir/;

sub asc_dir  {dir($Bin, qw/ DLS  asc /)};
sub xls_dir  {dir($Bin, qw/ DLS  xls /)};
sub dat_dir  {dir($Bin, qw/ graph dat /)};
sub plt_dir  {dir($Bin, qw/ graph plt /)};
sub ps_dir   {dir($Bin, qw/ graph ps /)};
sub log_dir   {dir($Bin, qw/ graph log /)};
sub img_dir  {dir($Bin, qw/ graph img /)};
sub param_dir {dir($Bin, qw/ graph param /)};
sub html_dir {dir($Bin, qw/ html /)};

