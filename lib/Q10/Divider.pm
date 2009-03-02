package Q10::Divider;
use strict;
use warnings;
use base qw/Class::Accessor::Lvalue::Fast/;
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;
use Q10::MoCo;
use Q10::Config;
use Q10::Gnuplot;
use Carp;
use List::Util qw/sum/;

__PACKAGE__->mk_accessors qw/divider  key  x  y  x_inv  y_inv  y_avg  x_logvalue  y_logvalue  logscale  range  _html  where  size  model  divider_model  with_lines/;

sub get_html {
    my $self = shift;
    $self->_html;
}

sub run {
    warn 'Divider run';
    my $self = shift;
    my $divider = $self->divider or croak 'no divider';
    my $key = $self->key or croak 'no key';
    my $x = $self->x or croak 'no x';
    my $y = $self->y or croak 'no y';
    my @where = qw/TRUE/;
    push @where, $self->where if $self->where;
    my $divider_model = $self->divider_model || 'DLSTrialCellSample';
    my $model = $self->model || 'DLSTrialCellSample';
    $divider_model = 'Sample' if $divider eq 'p8_ratio';
    my @divider = map {$_->$divider} moco($divider_model)->search(
        field => qq{distinct $divider},
        order => "$divider DESC",
        where => join ' AND ', @where,
    );
    for my $divider_val (@divider) {
        warn sprintf '%s = %s', $divider, $divider_val;
        my $file_name = sprintf '%s_%s_%s_%s_%s', $divider, $key, $x, $y, $divider_val;
        $file_name .= '_x_logvalue' if $self->x_logvalue;
        $file_name .= '_y_logvalue' if $self->y_logvalue;
        my $dat_file_name = dat_dir->file("$file_name.dat");
        my $plt_file_name = plt_dir->file("$file_name.plt");
        my $ps_file_name  = ps_dir->file("$file_name.ps");
        my $img_file_name = img_dir->file("$file_name.png");
        my $dat_file = IO::File->new($dat_file_name, 'w');
        warn $dat_file_name;
        my $plt_file = IO::File->new($plt_file_name, 'w');
        my $where = join ' AND ', (@where, qq{ $divider = ? });
        my @key = map {$_->$key} moco($model)->search(
            where => [$where, $divider_val],
            group => $key,
        );
        my $index = 0;
        my @dat_total, my @plot;
        my %phase_transition_hash = (
            i_to_n   => '1.I->N',
            i_to_b4  => '2.I->B4',
            n_to_cry => '3.N->Cry',
        );
#         warn $key;
        @key = sort {$phase_transition_hash{$a} cmp $phase_transition_hash{$b}} keys %phase_transition_hash if $key eq 'phase_transition_type';
        for my $key_val (@key) {
            warn sprintf '  %s = %s', $key, $key_val;
            my $where = join ' AND ', (@where, qq{ $divider = ? }, qq{ $key = ? });
            my @dls_trial = moco($model)->search(
                where => [$where, $divider_val, $key_val],
            );
            $self->with_lines and scalar @dls_trial == 1 and next;
            my @dat;
            my %dat;
            for my $dls_trial (@dls_trial) {
#                 warn 'HITTTTTTTT' if $dls_trial->date eq '2009-02-10';
                my $x_val = $x eq 'rotation_angle' ? $dls_trial->k : $dls_trial->$x;
                my $y_val = $y eq 'rotation_angle' ? $dls_trial->k : $dls_trial->$y;
                $x_val /= 10 if $x eq 'temperture';
                $y_val /= 10 if $y eq 'temperture';
                next if $x_val <= 0;
                next if $y_val <= 0;
                my $x_plot = $self->x_inv ? 1 / $x_val : $x_val;
                my $y_plot = $self->y_inv ? 1 / $y_val : $y_val;
                $x_plot = log($x_plot) if $self->x_logvalue;
                $y_plot = log($y_plot) if $self->y_logvalue;
                if ($self->y_avg) {
                    $dat{$x_plot} ||= [];
                    push @{$dat{$x_plot}}, $y_plot;
                } else {
                    push @dat, {x_plot => $x_plot, y_plot => $y_plot};
                }
            }
            if ($self->y_avg) {
                while (my ($dat_key, $dat_val) = each %dat) {
                    push @dat, {x_plot => $dat_key, y_plot => (sum @$dat_val)/scalar @$dat_val};
                }
            }
            @dat = map {sprintf "%s\t%s\n", $_->{x_plot}, $_->{y_plot}} sort {$a->{x_plot} <=> $b->{x_plot}} @dat;
            scalar @dat and unshift @dat, sprintf "# value = %s\n", $key_val;
            my $dat = join '', @dat or next;
            push @dat_total, $dat;
            my $title = sprintf '%s = %s', $key, $key_val;
            if ($key eq 'p8_ratio') {
                $title = sprintf '%s%% P8', $key_val;
            } elsif ($key eq 'temperture') {
                $title = sprintf '%s deg C', $key_val / 10;
            } elsif ($key eq 'phase_transition_type') {
                $title = $phase_transition_hash{$key_val};
            }
            push @plot, sprintf qq{'%s' ind %s %s t '%s'},
                $dat_file_name,
                    $index,
                        $self->with_lines ? 'w l' : '',
                            $title;
            $index++;
        }
        my $dat_total = join "\n\n", @dat_total or next;
        my $plot = join ',', @plot;
        $dat_file->print($dat_total);
        $dat_file->close;
        $dat_file->close;
        my @plt_content = (
            'set term postscript',
            'set key outside',
        );
        my ($x_label, $y_label) = ($x, $y);
        $x_label = "$x_label inverse" if $self->x_inv;
        $y_label = "$y_label inverse" if $self->y_inv;
        my $label_hash = {
            temperture                => 'Temperture[deg C]',
            correlation_max           => 'Correlation Max',
            count_rate_max            => 'Count Rate Max',
            rotation_angle            => 'k[/nm]',
            p8_ratio                  => 'P8 Ratio[%]',
            relaxation_time           => 'relaxation time[ms]',
            'relaxation_time inverse' => '1/relaxation time[/ms]',
            a                         => 'a',
            b                         => 'b',
            beta                      => 'beta',
            trial_num                 => 'trials',
            dls_day_count             => 'DLS Day Count',
            day_count                 => 'Day Count',
            microscope_count          => 'Microscope Day Count',
        };
        if (my $logscale = $self->logscale) {
            for (qw/x y/) {
                push @plt_content, qq{set logscale $_} if $logscale->{$_};
            }
        }
        push @plt_content, sprintf qq{set xlabel '%s'}, $label_hash->{$x_label};
        push @plt_content, sprintf qq{set ylabel '%s'}, $label_hash->{$y_label};
        if (my $size = $self->size) {
            push @plt_content, sprintf qq{set size %s,%s}, $size->{x} || 1, $size->{y} || 1,
        }
        if (my $range = $self->range) {
            my ($xrange, $yrange) = ($range->{x}, $range->{y});
            push @plt_content, sprintf qq{set xrange [%s:%s]\n}, $xrange->[0], $xrange->[1] if $xrange;
            push @plt_content, sprintf qq{set yrange [%s:%s]\n}, $yrange->[0], $yrange->[1] if $yrange;
        }
        push @plt_content, qq{set output '$ps_file_name'};
        push @plt_content, qq{plot $plot};
        my $plt_content .= join '', map {"$_\n"} @plt_content;
        $plt_file->print($plt_content);
        Q10::Gnuplot->run($plt_file_name);
        Q10::Gnuplot->convert($ps_file_name, $img_file_name);
        $self->_html .= sprintf qq{<h3>%s: %s </h3><img src="%s" />}, $divider, $divider_val, $img_file_name;
    }
}

1;
