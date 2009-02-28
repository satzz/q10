use strict;
use warnings;
use lib qw{./lib};
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;
use Q10::MoCo;
use Q10::Config;

for my $xls_file_name (grep { /csv/ } xls_dir->open->read) {
    my ($cell_id, $year, $month, $day) = $xls_file_name =~ /^cell(\d+)_(\d{2})(\d{2})(\d{2})[.]csv$/;
    my $dir = asc_dir->subdir("$year$month$day");
    warn $dir;
    mkdir "$dir";
    warn $cell_id;
    $cell_id = 16 or next;
    my $xls_file = xls_dir->file($xls_file_name);
    my ($photo_file_name, $rotation_angle, $sample_angle, $laser_position, $nd_filter_position, $polarizer_angle, $sample_position, $temperture);
    my $flag = 0;
    my @correlation, my @count_rate;
    my $io = IO::File->new($xls_file);
    my $row_index = 0;
    while (my $line = <$io>) {
        warn $row_index++;
        warn $flag;
        my $row = [split /,/, $line];
        my $head_cell = $row->[0];
        my $head = $head_cell || '';
        if ($head =~ /ファイル名/) {
            warn $head;
            $photo_file_name = $row;
        } elsif ($head =~ /散乱角ステージ/) {
            warn $head;
            $rotation_angle = $row;
        } elsif ($head =~ /サンプル回転角/) {
            warn $head;
            $sample_angle = $row;
        } elsif ($head =~ /レーザ位置/) {
            warn $head;
            $laser_position = $row;
        } elsif ($head =~ /ND設定位置/) {
            warn $head;
            $nd_filter_position = $row;
        } elsif ($head =~ /試料温度/) {
            warn $head;
            $temperture = $row;
        } elsif ($head =~ /偏光角/) {
            warn $head;
            $polarizer_angle = $row;
        } elsif ($head =~ /サンプルY/) {
            warn $head;
            $sample_position = $row;
        } elsif ($head eq 'VV') {
            warn $head;
            $flag = 1;
            next;
        }
        my $cell = $row->[2];
        my $val = $cell;
        if ($flag == 1) {
            warn $val;
            if ($val) {
#                 use Data::Dumper;
#                 warn Dumper $val;
                warn '$val is defined';
                push @correlation, $row;
            } else {
                warn '$val is undef';
                $flag = 2;
            }
        } elsif ($flag == 2 and $val) {
            $flag = 3;
        }
        if ($flag == 3) {
            push @count_rate, $row;
            defined $val or last;
        }
    }
    warn $#$temperture;
    for my $col_index ( 2 .. $#$temperture ) {
        next if $col_index % 2;
        warn $col_index;
        defined $correlation[0][$col_index] or last;
        chomp $_->[$col_index] for ($rotation_angle, $sample_angle, $laser_position, $nd_filter_position, $polarizer_angle, $sample_position);
        my $asc_file_name = sprintf
            'cell%s_%s_%s_%s_%s_%s_%s_%s.ASC',
                $cell_id,
                    $rotation_angle->[$col_index],
                        $sample_angle->[$col_index],
                            $laser_position->[$col_index],
                                $nd_filter_position->[$col_index],
                                    $polarizer_angle->[$col_index],
                                        $sample_position->[$col_index],
                                            $temperture->[$col_index] * 10;
        my $out = '';
        $out .= qq{"Correlation"\n};
        $out .= join "\n", map {sprintf "%s\t%s", $_->[$col_index], $_->[$col_index+1]} @correlation;
        $out .= qq{\n"Count Rate"\n};
        $out .= join "\n", map {sprintf "%s\t%s", $_->[$col_index], $_->[$col_index+1]} @count_rate;
        my $dir = asc_dir->subdir("$year$month$day");
        my $asc_file = IO::File->new(sprintf '>%s', $dir->file($asc_file_name));
        $asc_file->print ($out);
        $asc_file->close;
    }
}




