package DFA::Generate;

use integer;
use strict;
no strict 'refs';

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

use Carp;

require Exporter;

@ISA = qw(Exporter);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw();

$VERSION = '1.00';

# Preloaded methods go here.
#-------------------------------------------------------------------
# File:
#	Generate.pm.
#
# Purpose:
#	a. Read a  file containing a state transition table.
#	b. Generate a perl script which uses DFA::Command and
#		the state transition table, and which contains
#		functions generated from tokens in the table
#
# Version:
#	1.00	11-Apr-97	Ron Savage	rpsavage@ozemail.com.au
#
# Usage:
#	Step 1:
#		Fabricate Generate.pl. See *_Gen.pl for samples.
#	Step 2:
#		Prompt>perl Generate.pl Test.stt firstEvent          > Sample.pl
#	Step 3:
#		Prompt>perl Sample.pl   Test.stt firstEvent Real.dat > Sample.log
#-------------------------------------------------------------------

# Generate a Perl script from a state transition table.

sub generate
{
	my($self, $fileName, $firstEvent) = @_;

	my($visualBreak) = '#' . '-' x 65;

# Read the state transition table.

	my(@line);
	open(INX, $fileName) || croak("Can't open $fileName: $!");
	@line = <INX>;
	close(INX);
	chomp(@line);

# Discard all the comment & blank lines.

	@line = grep(! (/^\s*#/ || /^$/), @line);

	my($state, $RE, $event, $sub, $nextState, $validEvents);
	my(@sub, @counter);

	for (@line)
	{

# Split the lines of the state transition table,
# assuming the fields per line match:
# 0		1		2		3			4			5
# state	regExp	event	subroutine	nextState	validEvents

		($state, $RE, $event, $sub, $nextState, $validEvents) = split;

		push(@sub, $sub);

		push(@counter, $sub . "Count");
	}

# Besides the subroutine named in the state transition table,
# we will be generating functions with these names:

	push(@sub, 'init1File');
	push(@sub, 'report');

# Besides the scalars indirectly named in the state transition
# table, we will be generating scalars with these names:

#	push(@counter, 'lineCount');

# Find the scalar with the longest name, so we can make the
# output pretty.

	my($maxLength) = 0;
	my($counter);

	for $counter (sort(@counter) )
	{
		$maxLength = length($counter) if (length($counter) > $maxLength);
	}

# Ok. Output the heading of the Perl script.

	$self -> outputHeading($fileName, $firstEvent, $visualBreak);

# Output each function.

	for (sort(@sub) )
	{

# Function 'init1File' is special.

		if ($_ eq 'init1File')
		{
			print "sub $_\n{\n\n";

			for $counter (sort(@counter) )
			{
				print "\t\$$counter", ' ' x (1 + $maxLength - length($counter) ), "= 0;\n";
			}

			print "\n}\t# End of $_.\n\n";
			print "$visualBreak\n\n";

			next;
		}

# Function 'report' is special.

		if ($_ eq 'report')
		{
			$self -> outputReport($_, $visualBreak);
			next;
		}

# All others are from the state transition table.

		print "sub $_\n{\n";
		print "\t\$${_}Count++;\n\n";
		print "\t&report(\'$_\', \$${_}Count);\n\n";
		print "}\t# End of $_.\n\n";
		print "$visualBreak\n\n";
	}

	exit(1);

}	# End of generate.

#-------------------------------------------------------------------

# Print the fixed part of the script being generated.

sub outputHeading
{
	my($self, $fileName, $firstEvent, $visualBreak) = @_;

	print <<EndOfHereDoc;
#!/usr/gnu/bin/perl -w
#
# Name:
#	Generated.pl.
#
# Purpose:
#	Exercise the DFA::Command module.
#
# Usage:
#	...>perl Generated.pl $fileName $firstEvent Real.dat
#
# Version:
#	0.00	11-Apr-97	Ron Savage	rpsavage\@ozemail.com.au
#-------------------------------------------------------------------

# Initialize.

require 5.000;

use integer;
use Getopt::Std;
use DFA::Command;

# Stop a warning issued by -w for the debug option.

\$opt_d = 0;

getopts('d');

\$sttFileName	= shift;
\$firstEvent		= shift;

\$stateMachine = new DFA::Command(\$firstEvent);
# or
#\$stateMachine = DFA::Command -> new(\$firstEvent);

\$stateMachine -> load(\$sttFileName);

if (\$opt_d)
{
	print '-' x 32, "\\nStart of state transition table. \\n", '-' x 32, "\\n\\n";

	\$stateMachine -> dump();

	print '-' x 30, "\\nEnd of state transition table. \\n", '-' x 30, "\\n\\n";
}

# Process the one input file.

for \$fileName (\@ARGV)
{
	&init1File();
	\$stateMachine -> process(\$fileName);
}

exit(1);

$visualBreak
$visualBreak

EndOfHereDoc

}	# End of outputHeading.

#-------------------------------------------------------------------

# Print the variable of the script being generated.

sub outputReport
{
	my($self, $name, $visualBreak) = @_;

	print <<EndOfHereDoc;
sub $name
{
	my(\$stemName, \$stemCount) = \@_;

	print "\$stemName: \$stemCount. \\n";
	print "Original: \$stateMachine->{'original'} \\n";
	print "Clean:    \$stateMachine->{'clean'} \\n\";
	print "Found: <\$stateMachine->{'\$1'}>. \\n\"
		if (defined(\$stateMachine -> {'\$1'}) );
	print "\\n";

}\t# End of $name.

$visualBreak

EndOfHereDoc

}	# End of outputReport.

#-------------------------------------------------------------------

# Autoload methods go after =cut, and are processed by the autosplit program.

1;

__END__
