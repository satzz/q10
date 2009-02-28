package Q10::MoCo::MicroscopeTrialPhaseTransition;
use strict;
use warnings;
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;
use Q10::MoCo;
use base moco;

__PACKAGE__->table('microscope_trial_phase_transition');

sub loaded_time {
    my $self = shift;
    my $res =
        moco('DLSTrial')->search(where => ['cell_id = :cell_id and date < :date and temperture > 140', cell_id => $self->cell_id, date => $self->date])->length * 0.5
            + moco('MicroscopeTrial')->search(where => ['microscope_trial_id > 12 and microscope_trial_id < :microscope_trial_id and cell_id = :cell_id', cell_id => $self->cell_id, microscope_trial_id => $self->microscope_trial_id])->length * 30;
    $self->{_trial_num} ||= $res;
}



1;
