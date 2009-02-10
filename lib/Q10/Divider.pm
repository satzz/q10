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

__PACKAGE__->mk_accessors qw/divider  key  x  y  logscale  range  _html  where/;

sub get_html {
    my $self = shift;
    $self->_html;
}

sub run {
    my $self = shift;
    my $divider = $self->divider or croak 'no divider';
    my $key = $self->key or croak 'no key';
    my $x = $self->x or croak 'no x';
    my $y = $self->y or croak 'no y';
    my ($x_inv, $y_inv);
    if ($x =~ / inverse/) {
        $x_inv = 1;
        $x =~ s/ inverse//g;
    }
    if ($y =~ / inverse/) {
        $y_inv = 1;
        $y =~ s/ inverse//g;
    }

    my @where = qw/TRUE/;
    push @where, $self->where if $self->where;
    my @divider = map {$_->$divider} moco('DLSTrialCellSample')->search(
        field => qq{distinct $divider},
        order => "$divider DESC",
        where => join ' AND ', @where,
    );
    for my $divider_val (@divider) {
        my $dat_file_name = dat_dir->file(sprintf '%s_%s_%s_%s_%s.dat', $divider, $key, $x, $y, $divider_val);
        my $plt_file_name = plt_dir->file(sprintf '%s_%s_%s_%s_%s.plt', $divider, $key, $x, $y, $divider_val);
        my $ps_file_name  = ps_dir->file(sprintf '%s_%s_%s_%s_%s.ps', $divider, $key, $x, $y, $divider_val);
        my $img_file_name = img_dir->file(sprintf '%s_%s_%s_%s_%s.png', $divider, $key, $x, $y, $divider_val);
        my $dat_file = IO::File->new($dat_file_name, 'w');
        my $plt_file = IO::File->new($plt_file_name, 'w');
        my $where = join ' AND ', (@where, qq{ $divider = ? });
        my @key = map {$_->$key} moco('DLSTrialCellSample')->search(
            where => [$where, $divider_val],
            group => $key,
        );
        my $index = 0;
        my @dat_total, my @plot;
        for my $key_val (@key) {
            my $where = join ' AND ', (@where, qq{ $divider = ? }, qq{ $key = ? });
            my @dls_trial = moco('DLSTrialCellSample')->search(
                where => [$where, $divider_val, $key_val],
            );
            scalar @dls_trial > 3 or next;
            my @dat;
            for my $dls_trial (@dls_trial) {
                my $x_val = $x eq 'rotation_angle' ? $dls_trial->k : $dls_trial->$x;
                my $y_val = $y eq 'rotation_angle' ? $dls_trial->k : $dls_trial->$y;
                $x_val /= 10 if $x eq 'temperture';
                $y_val /= 10 if $y eq 'temperture';
                next if $x_val <= 0;
                next if $y_val <= 0;
                my $x_plot = $x_inv ? 1 / $x_val : $x_val;
                my $y_plot = $y_inv ? 1 / $y_val : $y_val;
                push @dat, sprintf "%s\t%s\n", $x_plot, $y_plot;
            }
            scalar @dat and unshift @dat, sprintf "# %s\n", $key_val;
            my $dat = join '', @dat or next;
            push @dat_total, $dat;
            my $title = $key_val;
            push @plot, sprintf qq{'%s' ind %s t '%s'}, $dat_file_name, $index, $title;
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
        my $label_hash = {
            temperture                => 'Temperture[deg C]',
            rotation_angle            => 'k[1/nm]',
            p8_ratio                  => 'P8 Ratio[%]',
            relaxation_time           => 'relaxation time[ms]',
            'relaxation_time inverse' => '1/relaxation time[/ms]',
        };
        if (my $logscale = $self->logscale) {
            for (qw/x y/) {
                push @plt_content, qq{set logscale $_} if $logscale->{$_};
            }
        }
        push @plt_content, sprintf qq{set xlabel '%s'}, $label_hash->{$x};
        push @plt_content, sprintf qq{set ylabel '%s'}, $label_hash->{$y};
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
