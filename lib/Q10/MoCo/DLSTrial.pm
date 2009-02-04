package Q10::MoCo::DLSTrial;
use strict;
use warnings;
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;
use Q10::MoCo;
use base moco;

__PACKAGE__->table('dls_trial');

__PACKAGE__->has_a(
    cell => moco('Cell'),
    {
        key => { cell_id => 'cell_id' },
    }
);

sub sample {
    my $cell = shift->cell or return;
    $cell->sample;
}

sub p8_ratio {
    my $sample = shift->sample or return;
    $sample->p8_ratio;
}

sub k {
    my $lambda = 532;
    4 * 3.14 / $lambda *sin (shift->rotation_angle * 0.003 /2);
}

1;
