package Q10::MoCo::Cell;
use strict;
use warnings;
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;
use Q10::MoCo;
use base moco;

__PACKAGE__->table('cell');

__PACKAGE__->has_a(
    sample => moco('Sample'),
    {
        key => { sample_id => 'sample_id' },
    }
);

sub p8_ratio {
    my $sample = shift->sample or return;
    $sample->p8_ratio;
}

1;
