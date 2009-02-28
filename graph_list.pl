use strict;
use warnings;
use lib qw{./lib};
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;
use Q10::MoCo;
use Q10::Divider;
use Q10::Config;
use Q10::Gnuplot;


my $html_file_name = html_dir->file('trial_list.html');
my $html_file = IO::File->new($html_file_name, 'w');
my $html = '';

my @dls_trial = moco('DLSTrial')->search(order => 'relaxation_time asc', where => 'relaxation_time > 0');
$html .= qq{<table border=1>\n};
$html .= qq{<tr><th>ID</th><th>Temp</th><th>P8[%]</th><th>Correlation Max</th><th>Relx.Time[ms]</th><th>date</th></tr>\n};
for my $dls_trial (@dls_trial) {
    $dls_trial->date eq '2009-02-26' or $dls_trial->date eq '2009-02-27' or $dls_trial->date eq '2009-02-28' or next;
    my $dls_trial_id = $dls_trial->dls_trial_id;
    my $img_file_name = img_dir->file("correlation_dls_$dls_trial_id.png");
    $html .= sprintf qq{<tr><td><a href="$img_file_name" target="target">%s</a></td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n},
        $dls_trial_id,
            $dls_trial->temperture /10,
                $dls_trial->p8_ratio,
                    $dls_trial->correlation_max,
                        $dls_trial->relaxation_time,
                            $dls_trial->date;
}
$html .= qq{</table>};


$html_file->print($html);
$html_file->close;




