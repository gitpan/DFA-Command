#!/usr/gnu/bin/perl -w
#
# Name:
#	Generated.pl.
#
# Purpose:
#	Exercise the DFA::Command module.
#
# Usage:
#	...>perl Generated.pl Citizen.stt headerEvent Real.dat
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

sub addCitizenFn
{
	$addCitizenFnCount++;

	&report('addCitizenFn', $addCitizenFnCount);

}	# End of addCitizenFn.

#-----------------------------------------------------------------

sub addEmailFn
{
	$addEmailFnCount++;

	&report('addEmailFn', $addEmailFnCount);

}	# End of addEmailFn.

#-----------------------------------------------------------------

sub addFamilyFn
{
	$addFamilyFnCount++;

	&report('addFamilyFn', $addFamilyFnCount);

}	# End of addFamilyFn.

#-----------------------------------------------------------------

sub addGivenFn
{
	$addGivenFnCount++;

	&report('addGivenFn', $addGivenFnCount);

}	# End of addGivenFn.

#-----------------------------------------------------------------

sub dateFn
{
	$dateFnCount++;

	&report('dateFn', $dateFnCount);

}	# End of dateFn.

#-----------------------------------------------------------------

sub deleteCitizenFn
{
	$deleteCitizenFnCount++;

	&report('deleteCitizenFn', $deleteCitizenFnCount);

}	# End of deleteCitizenFn.

#-----------------------------------------------------------------

sub deleteFamilyFn
{
	$deleteFamilyFnCount++;

	&report('deleteFamilyFn', $deleteFamilyFnCount);

}	# End of deleteFamilyFn.

#-----------------------------------------------------------------

sub deleteGivenFn
{
	$deleteGivenFnCount++;

	&report('deleteGivenFn', $deleteGivenFnCount);

}	# End of deleteGivenFn.

#-----------------------------------------------------------------

sub endAddCitizenFn
{
	$endAddCitizenFnCount++;

	&report('endAddCitizenFn', $endAddCitizenFnCount);

}	# End of endAddCitizenFn.

#-----------------------------------------------------------------

sub endDeleteCitizenFn
{
	$endDeleteCitizenFnCount++;

	&report('endDeleteCitizenFn', $endDeleteCitizenFnCount);

}	# End of endDeleteCitizenFn.

#-----------------------------------------------------------------

sub endHeaderFn
{
	$endHeaderFnCount++;

	&report('endHeaderFn', $endHeaderFnCount);

}	# End of endHeaderFn.

#-----------------------------------------------------------------

sub headerFn
{
	$headerFnCount++;

	&report('headerFn', $headerFnCount);

}	# End of headerFn.

#-----------------------------------------------------------------

sub init1File
{

	$addCitizenFnCount       = 0;
	$addEmailFnCount         = 0;
	$addFamilyFnCount        = 0;
	$addGivenFnCount         = 0;
	$dateFnCount             = 0;
	$deleteCitizenFnCount    = 0;
	$deleteFamilyFnCount     = 0;
	$deleteGivenFnCount      = 0;
	$endAddCitizenFnCount    = 0;
	$endDeleteCitizenFnCount = 0;
	$endHeaderFnCount        = 0;
	$headerFnCount           = 0;

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

