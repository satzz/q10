package Q10::MoCo;
use strict;
use warnings;
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;

use base qw/DBIx::MoCo/;
use UNIVERSAL::require;
use Exporter::Lite;
use Q10::DataBase;

our @EXPORT = qw/moco/;

__PACKAGE__->db_object('Q10::DataBase');

sub moco (@) {
    my $model = shift or return __PACKAGE__;
    $model = "Q10::MoCo::$model";
    $model->require or die $@;
    $model;
}

1;
