use strict;
use warnings;
use lib qw{./lib};
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;
use Q10::MoCo;

my $xls_dir = dir($Bin, qw/ DLS  xls /);
for my $xls_file_name (grep { /txt/ } $xls_dir->open->read) {
    my ($cell_id, $year, $month, $day) = $xls_file_name =~ /^cell(\d+)_(\d{2})(\d{2})(\d{2})[.]txt$/;
    my $xls_file = $xls_dir->file($xls_file_name);
    my ($photo_file_name, $rotation_angle, $sample_angle, $laser_position, $nd_filter_position, $polarizer_angle, $sample_position, $temperture);
    my $flag = 0;
    my @correlation, my @count_rate;
    my $io = IO::File->new($xls_file);
    my $row_index = 0;
    while (my $line = <$io>) {
        $row_index++;
        my $row = [split /\s+/, $line];
        my $head_cell = $row->[0];
        my $head = $head_cell || '';
        if ($head eq 'ファイル名') {
            $photo_file_name = $row;
        } elsif ($head eq '散乱角ステージ') {
            $rotation_angle = $row;
        } elsif ($head eq 'サンプル回転角') {
            $sample_angle = $row;
        } elsif ($head eq 'レーザ位置') {
            $laser_position = $row;
        } elsif ($head eq 'ND設定位置') {
            $nd_filter_position = $row;
        } elsif ($head eq '試料温度') {
            $temperture = $row;
        } elsif ($head eq '偏光角') {
            $polarizer_angle = $row;
        } elsif ($head eq 'サンプルY') {
            $sample_position = $row;
        } elsif ($head eq 'VV') {
            $flag = 1;
            next;
        }
        my $cell = $row->[2];
        my $val = $cell;
        if ($flag == 1) {
            if (defined $val) {
                push @correlation, $row;
            } else {
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
    for my $col_index ( 2 .. $#$temperture ) {
        next if $col_index % 2;
        defined $correlation[0][$col_index] or last;
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
        $out .= qq{"Count Rate"\n};
        $out .= join "\n", map {sprintf "%s\t%s", $_->[$col_index-1], $_->[$col_index]} @count_rate;
        my $dir = dir($Bin, qw/ DLS asc /, "$year$month$day");
        mkdir "$dir";
        my $asc_file = IO::File->new(sprintf '>%s', $dir->file($asc_file_name));
        $asc_file->print ($out);
        $asc_file->close;
    }
}




