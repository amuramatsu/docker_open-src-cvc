#! /usr/bin/perl

use strict;
use warnings;
use Cwd;

my $OUTPUT = "cvcsim";                 # Default output is 'cvcsim'
my $IMAGE_NAME = "amura/open-src-cvc"; # image name 
my $COMMAND = "/usr/bin/cvc64";        # cvc executable in container

sub modify_exec {
    my ($filename) = @_;
    if (-e $filename) {
	rename $filename => "$filename.bin" or die;
	open my $newfile, '>', $filename or die;
	binmode($newfile);
	print $newfile <<"__EOS__";
#! /bin/sh
exec docker run -u \$UID -v "\$(pwd):/work" --rm -it amura/open-src-cvc ./$filename.bin "\$\@"
__EOS__
	close $newfile;
	chmod 0755, $filename;
    }
}

# check output file
my $next_is_output = 0;
my $next_skip = 0;
for my $arg (@ARGV) {
    if ($next_skip) {
	$next_skip = 0;
    }
    elsif ($next_is_output) {
	$OUTPUT = $arg;
	$next_is_output = 0;
    }
    elsif ($arg eq "-o") {
	$next_is_output = 1;
    }
    elsif ($arg eq "+exe" || $arg eq "+interp") {
	$OUTPUT = "";
    }
    elsif ($arg eq "+maxerrors") {
	# set max error numbers
	$next_skip = 1;
    }
    elsif ($arg eq "-f" || $arg eq "-l" || $arg eq "-i" ||
	   $arg eq "-v" || $arg eq "-optconfigfile" ||
	   $arg eq "+tracefile" ||
	   $arg eq "-sdf_log_file" || $arg eq "-sdf_annotate" ||
	   $arg eq "-toggle_file" || $arg eq "-write_doggle_data_file" ||
	   $arg eq "-set_toggled_from_file" ||
	   $arg eq "-stmt_coverage_file" || $arg eq "-sv_lib") {
	# set filename
	$next_skip = 1;
    }
    elsif ($arg eq "-y") {
	# set library path
	$next_skip = 1;
    }
    #elsif ($arg =~ /^\+incdir\+/) {
    #    # set include path
    #}
}
my $s = system("docker", "run", "-u", $<, "-v", Cwd::getcwd() . ":/work",
	       "--rm", "-it", $IMAGE_NAME, $COMMAND, @ARGV);
modify_exec($OUTPUT) if $OUTPUT ne "";
exit $s;
