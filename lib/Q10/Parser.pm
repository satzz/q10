package Q10::Parser;
use strict;
use warnings;
use Data::Dumper;

sub parse {
    my $class = shift;
    my $param_file_name = shift or return;
    $param_file_name->isa('Path::Class::File') or return;
    my $content = $param_file_name->slurp;
    my %param = $content =~ /(\w+) \s+ = \s+ (.+) /xg;
    \%param;
}

1;

