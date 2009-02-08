package Q10::MoCo::DLSTrialCellSample;
use strict;
use warnings;
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;
use Q10::MoCo;
use base ('DBIx::MoCo::Join', moco('DLSTrial'), moco('Cell'), moco('Sample'));

__PACKAGE__->table('dls_trial inner join cell using (cell_id) inner join sample using (sample_id)');
__PACKAGE__->db_object('Q10::DataBase');

__PACKAGE__->has_a(
    cell => moco('Cell'),
    {
        key => { cell_id => 'cell_id' },
    }
);

__PACKAGE__->has_a(
    sample => moco('Sample'),
    {
        key => { sample_id => 'sample_id' },
    }
);

1;
