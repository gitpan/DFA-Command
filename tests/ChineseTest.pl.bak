#!/usr/gnu/bin/perl -w
#
# Name:
#	Generated.pl.
#
# Purpose:
#	Exercise the DFA::Command module.
#
# Usage:
#	...>perl Generated.pl Chinese.stt StartEvent Real.dat
#
# Version:
#	0.00	11-Apr-97
#
# Author:
#	Ron Savage <ron@savage.net.au>
#	http://savage.net.au/index.html
#-------------------------------------------------------------------

# Initialize.

require 5.000;

use Getopt::Std;
use DFA::Command;

# Stop a warning issued by -w for the debug option.

$opt_d = 0;

getopts('d');

$sttFileName	= shift;
$firstEvent		= shift;

$stateMachine = new DFA::Command($firstEvent);
# or
#$stateMachine = DFA::Command -> new($firstEvent);

$stateMachine -> load($sttFileName);

if ($opt_d)
{
	print '-' x 32, "\nStart of state transition table. \n", '-' x 32, "\n\n";

	$stateMachine -> dump();

	print '-' x 30, "\nEnd of state transition table. \n", '-' x 30, "\n\n";
}

# Process the one input file.

for $fileName (@ARGV)
{
	&init1File();
	$stateMachine -> process($fileName);
}

exit(1);

#-----------------------------------------------------------------
#-----------------------------------------------------------------

sub FinishFn
{
	$FinishFnCount++;

	&report('FinishFn', $FinishFnCount);

}	# End of FinishFn.

#-----------------------------------------------------------------

sub RenFn
{
	$RenFnCount++;

	&report('RenFn', $RenFnCount);

}	# End of RenFn.

#-----------------------------------------------------------------

sub StartFn
{
	$StartFnCount++;

	&report('StartFn', $StartFnCount);

}	# End of StartFn.

#-----------------------------------------------------------------

sub ZhongguoFn
{
	$ZhongguoFnCount++;

	&report('ZhongguoFn', $ZhongguoFnCount);

}	# End of ZhongguoFn.

#-----------------------------------------------------------------

sub ZhongguohuaFn
{
	$ZhongguohuaFnCount++;

	&report('ZhongguohuaFn', $ZhongguohuaFnCount);

}	# End of ZhongguohuaFn.

#-----------------------------------------------------------------

sub init1File
{

	$FinishFnCount      = 0;
	$RenFnCount         = 0;
	$StartFnCount       = 0;
	$ZhongguoFnCount    = 0;
	$ZhongguohuaFnCount = 0;

}	# End of init1File.

#-----------------------------------------------------------------

sub report
{
	my($stemName, $stemCount) = @_;

	print "$stemName: $stemCount. \n";
	print "Original: $stateMachine->{'original'} \n";
	print "Clean:    $stateMachine->{'clean'} \n";
	print "Found: <$stateMachine->{'$1'}>. \n"
		if (defined($stateMachine -> {'$1'}) );
	print "\n";

}	# End of report.

#-----------------------------------------------------------------

