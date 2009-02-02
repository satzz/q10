package Q10::DataBase;
use strict;
use warnings;
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;
use Q10::MoCo;
use base qw/DBIx::MoCo::DataBase/;

__PACKAGE__->dsn('dbi:mysql:dbname=q10');
__PACKAGE__->username('nobody');
__PACKAGE__->password('nobody');


