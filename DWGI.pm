package CAD::Drawing::IO::DWGI;
our $VERSION = '0.10';

use 5.006;
use strict;
use warnings;

BEGIN {
	my $dir = __FILE__;
	$dir =~ s#.pm$#/#;
	our $functions = $dir . "functions.c";
	# print "functions at begin: $functions\n";
}

use Inline (
		C => Config => 
		INC => '-I/usr/local/include',
		MYEXTLIB => '/usr/local/lib/ad2.a /usr/local/lib/ad2pic.a',
		NAME => "CAD::Drawing::IO::DWGI",
		FILTERS => 'Strip_POD',
		VERSION => '0.10',
		# CLEAN_AFTER_BUILD => 0,
#        FORCE_BUILD => 1,
		# NOTE:  you can just call this with -MInline=NOISY,NOCLEAN,etc
		);
our $functions;
use Inline C => $functions;

# NOTE: this file contains little or no Perl code, the entire module is
# implemented using the Inline.pm module and all C code is contained in
# the file functions.c (the contents of which are distributed under the
# __DATA__ section below.)

=pod

=head1 NAME

CAD::Drawing::IO::DWGI - Perl bindings to the OpenDWG toolkit

=head1 WARNING

This module is intended to serve as a backend to CAD::Drawing and is not
guaranteed to remain interface stable.  Do not use this module directly
unless you have a need for higher-speed access than that which is
provided by CAD::Drawing (which also provides loads of other features.)

Just 

  use CAD::Drawing 

=head1 AUTHOR

  Eric L. Wilhelm
  ewilhelm AT sbcglobal DOT net
  http://pages.sbcglobal.net/mycroft

=head1 COPYRIGHT

This module is copyright 2003 by Eric L. Wilhelm and A. Zahner Co.  

This is module is free software as described under the terms below.
Permission to use, modify and distribute this module shall be governed
by these terms (the module code is distributed and licensed
independently from the OpenDWG consortium's code.)  All notices and
disclaimers must remain intact with any copies of this software.

=head1 LICENSE

This module is distributed under the same terms as Perl.  See the Perl
source package for details.

=head1 REQUIREMENTS

You must obtain and install the OpenDWG libraries from the OpenDWG
consortium in order to use this module.  By using this module, you have
the responsibility to adhere to both the licensing of this module and
the licensing of the OpenDWG consortium.

=head1 SYNOPSIS

  use CAD::Drawing::IO::DWGI;
  $dwg = CAD::Drawing::IO::DWGI->new();
  $dwg->loadfile("file.dwg");
  $dwg->getentinit();
  while(my($layer, $color, $type) = $dwg->getent()) {
    my $type = $dwg->entype($type);
    if($type eq "lines") {
      $line = $dwg->getLine();
      }
    }
  
  $dxf = CAD::Drawing::IO::DWGI->new();
  $dxf->newfile(1);
  $dxf->getentinit();
  $dxf->writeCircle({"pt"=>[$x, $y], "rad" => 1.125, "color" => 9});
  $dxf->savefile("check.dxf", 1);

=head1 SPEED

Wow!  This is fast!  I had originally implemented this with a
function-call based wrapper which had the drawback that the layerhandle
had to be found for every object which was being saved.  See the
writeLayer() and setLayer() functions below for details of the improved
methods.  Also note that while the speed is amazing from this level,
very little speed is lost by moving up a level to using CAD::Drawing
(please do this.)

=head1 Accuracy

The dxf file accuracy is set internally at 14 digits after the decimal
place.  Providing an interface to set this would take a bit of coding
in C, so you are more than welcome to submit a patch.

=cut

=head1 Changes

  0.08 First public release
  0.09 Fixed error reading image size
  0.10 Added Ellipse read

=cut

1;
