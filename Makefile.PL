use Inline::MakeMaker;
use File::Find;
use Getopt::Long;
my $ad_init;
GetOptions(
	"help" => sub {usage()},
	"adinit=s" => \$ad_init,
	);
sub usage {
	print "usage: perl $0 [--help], [--adinit <initfile>]\n";
	exit;
}
unless($ad_init and (-e $ad_init)) {
	print "searching your hard-drive for adinit.dat ...\n";
	foreach my $dir ("/usr/", "/home/") {
		find(
		sub {
			if($_ eq "adinit.dat") {
				($File::Find::name =~ m#/ptc/#) && next;
				$ad_init = $File::Find::name;
				last;	
			}
		}, $dir);
		$ad_init && last;
	}
	$ad_init or die "could not find any adinit.dat file\n\t";
	print "found $ad_init\n";
	open(FUNC, "DWGI/functions.c") or die "cannot read functions.c!";
	my @file = <FUNC>;
	my $okay;
	foreach my $line (@file) {
		if($line =~ s/(const char initfilepath\[\]=").*?";/$1$ad_init";/) {
			$okay++;
			last;
		}
	}
	$okay or die "failed to insert initfilename\n";
	open(FUNC, ">DWGI/functions.c") or die "cannot write functions.c!";
	print FUNC @file;
	close(FUNC);
}
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'CAD::Drawing::IO::DWGI',
    'VERSION_FROM'	=> 'DWGI.pm', # finds $VERSION
	'MAN3PODS' => {
		'DWGI.pod' => "blib/man3/CAD::Drawing::IO::DWGI.3pm",
		},
    'PREREQ_PM'		=> {
    	Inline => 0,
	Inline::Filters => 0,
        },
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'DWGI.pm', # retrieve abstract from module
       AUTHOR     => 'Eric L. Wilhelm <ewilhelm at sbcglobal dot net>') : ()),
);
