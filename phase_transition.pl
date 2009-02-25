use strict;
use warnings;
use lib qw{./lib};
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;
use Q10::MoCo;
use Q10::Config;
use Q10::Divider;
use Q10::Gnuplot;

my $dat_file_name    = dat_dir->file('phase_transition.dat');
my $dat_ln_file_name = dat_dir->file('phase_transition.dat');
my $plt_file_name    = plt_dir->file('phase_transition.plt');
my $dat_file = IO::File->new($dat_file_name, 'w');
my $dat_ln_file = IO::File->new($dat_ln_file_name, 'w');
my $plt_file = IO::File->new($plt_file_name, 'w');

{
    my $html_file_name = html_dir->file('phase_transition.html');
    my $html_file = IO::File->new($html_file_name, 'w');
    my $html = '';
    my $divider1 = Q10::Divider->new;
    $divider1->model         = 'MicroscopeTrialPhaseTransitionCellSample';
    $divider1->divider_model = 'MicroscopeTrial';
    $divider1->divider       = 'temp_column';
    $divider1->key           = 'phase_transition_type';
    $divider1->x             = 'p8_ratio';
    $divider1->y             = 'temperture';
    $divider1->y_avg         = 1;
    $divider1->size          = {x => 1.5};
    $divider1->where         = 'microscope_trial_id NOT IN (12, 25, 26)';
    $divider1->with_lines    = 1;
    $divider1->run;
    $html .= $divider1->get_html;
    $html_file->print($html);
    $html_file->close;
}







