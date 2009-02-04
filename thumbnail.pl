use strict;
use warnings;
use lib qw{./lib};
use FindBin qw/$Bin/;
use IO::File;
use Data::Dumper;
use Path::Class;
use Q10::MoCo;
use Q10::Gnuplot;

use File::Find;

my $img_dir = dir($Bin, qw/ graph img /);
my $tn_dir = dir($Bin, qw/ graph img thumbnail /);
unlink $tn_dir->file($_) for grep {/png/} $tn_dir->open->read;

my $width = 200;
my $height = 150;
for my $file_name (grep {/png/} $img_dir->open->read) {
    system sprintf 'convert -resize %sx%s %s %s', $width, $height, $img_dir->file($file_name), $tn_dir->file($file_name);
    last;
}


# find( { wanted => \&filter, no_chdir => 1 }, $img_dir );

# sub filter {
#     my $name;
#     my $dir;
#     eval {
#         $name = $File::Find::name;
#         $dir  = $File::Find::dir;
#         return if ( $name !~ /jpg$/ );

#         ## 画像縮小
#         my $img = Image::Magick->new;
#         $img->Read($name);
#         my ( $x, $y ) = $img->Get( 'width', 'height' );
#         if ( $x > $y * $RESIZE_X / $RESIZE_Y ) {
#             $img->Resize( width => $x * $RESIZE_Y / $y, height => $RESIZE_Y );
#             $img->Crop( width => $RESIZE_X, height => $RESIZE_Y, x => ( $x * $RESIZE_Y / $y - $RESIZE_X ) / 2, y => 0 );
#         }
#         else {
#             $img->Resize( width => $RESIZE_X, height => $y * $RESIZE_X / $x );
#             $img->Crop( width => $RESIZE_X, height => $RESIZE_Y, x => 0, y => ( $y * $RESIZE_X / $x - $RESIZE_Y ) / 2 );
#         }
#         binmode(STDOUT);
#         my ($newname) = $name =~ m!.+(/.+)\..+$!;
#         my $new_file = $tn_dir->file("$newname.png");
#         print qq{$name -> $new_file\n};
#         $img->Write("png:$new_file");
#     };
#     if ($@) {
#         warn "$name : $@ \n";
#     }
# }
