package Q10::MoCo::MicroscopeTrialPhaseTransitionCellSample;
use strict;
use warnings;
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;
use Q10::MoCo;
use base ('DBIx::MoCo::Join', moco('MicroscopeTrialPhaseTransition'), moco('MicroscopeTrial'), moco('Cell'), moco('Sample'));

__PACKAGE__->table('microscope_trial_phase_transition inner join microscope_trial using (microscope_trial_id) inner join cell using (cell_id) inner join sample using (sample_id)');
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

sub dls_day_count {
    my $self = shift;
    moco('DLSTrial')->search(field => 'count(distinct date) as dls_day_count', where => ['date < :date', date => $self->date])->first->dls_day_count || 0;
}

sub microscope_day_count {
    my $self = shift;
    moco('MicroscopeTrial')->search(field => 'count(distinct date) as microscope_day_count', where => ['date < :date', date => $self->date])->first->microscope_day_count || 0;
}

sub day_count {
    my $self = shift;
#     $self->dls_day_count + $self->microscope_day_count;
    use Date::Simple;
    my $date = Date::Simple->new($self->date);
    $date - Date::Simple->new('2008-12-07');
}
1;
