#!/usr/gnu/bin/perl -w
#
# Name:
#	X500DN.pl.
#
# Purpose:
#	Exercise the DFA::Command module.
#
# Usage:
#	...>perl X500DN.pl X500DN.stt headerEvent Real.dat
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

sub addCDNFn
{
	$addCDNFnCount++;

	&report('addCDNFn', $addCDNFnCount);

}	# End of addCDNFn.

#-----------------------------------------------------------------

sub addCFn
{
	$addCFnCount++;

	&report('addCFn', $addCFnCount);

}	# End of addCFn.

#-----------------------------------------------------------------

sub addCNAttributesFn
{
	$addCNAttributesFnCount++;

	&report('addCNAttributesFn', $addCNAttributesFnCount);

}	# End of addCNAttributesFn.

#-----------------------------------------------------------------

sub addCNDNFn
{
	$addCNDNFnCount++;

	&report('addCNDNFn', $addCNDNFnCount);

}	# End of addCNDNFn.

#-----------------------------------------------------------------

sub addCNFn
{
	$addCNFnCount++;

	&report('addCNFn', $addCNFnCount);

}	# End of addCNFn.

#-----------------------------------------------------------------

sub addCNSurnameFn
{
	$addCNSurnameFnCount++;

	&report('addCNSurnameFn', $addCNSurnameFnCount);

}	# End of addCNSurnameFn.

#-----------------------------------------------------------------

sub addODNFn
{
	$addODNFnCount++;

	&report('addODNFn', $addODNFnCount);

}	# End of addODNFn.

#-----------------------------------------------------------------

sub addOFn
{
	$addOFnCount++;

	&report('addOFn', $addOFnCount);

}	# End of addOFn.

#-----------------------------------------------------------------

sub addOUDNFn
{
	$addOUDNFnCount++;

	&report('addOUDNFn', $addOUDNFnCount);

}	# End of addOUDNFn.

#-----------------------------------------------------------------

sub addOUFn
{
	$addOUFnCount++;

	&report('addOUFn', $addOUFnCount);

}	# End of addOUFn.

#-----------------------------------------------------------------

sub dateFn
{
	$dateFnCount++;

	&report('dateFn', $dateFnCount);

}	# End of dateFn.

#-----------------------------------------------------------------

sub deleteCDNFn
{
	$deleteCDNFnCount++;

	&report('deleteCDNFn', $deleteCDNFnCount);

}	# End of deleteCDNFn.

#-----------------------------------------------------------------

sub deleteCFn
{
	$deleteCFnCount++;

	&report('deleteCFn', $deleteCFnCount);

}	# End of deleteCFn.

#-----------------------------------------------------------------

sub deleteCNDNFn
{
	$deleteCNDNFnCount++;

	&report('deleteCNDNFn', $deleteCNDNFnCount);

}	# End of deleteCNDNFn.

#-----------------------------------------------------------------

sub deleteCNFn
{
	$deleteCNFnCount++;

	&report('deleteCNFn', $deleteCNFnCount);

}	# End of deleteCNFn.

#-----------------------------------------------------------------

sub deleteODNFn
{
	$deleteODNFnCount++;

	&report('deleteODNFn', $deleteODNFnCount);

}	# End of deleteODNFn.

#-----------------------------------------------------------------

sub deleteOFn
{
	$deleteOFnCount++;

	&report('deleteOFn', $deleteOFnCount);

}	# End of deleteOFn.

#-----------------------------------------------------------------

sub deleteOUDNFn
{
	$deleteOUDNFnCount++;

	&report('deleteOUDNFn', $deleteOUDNFnCount);

}	# End of deleteOUDNFn.

#-----------------------------------------------------------------

sub deleteOUFn
{
	$deleteOUFnCount++;

	&report('deleteOUFn', $deleteOUFnCount);

}	# End of deleteOUFn.

#-----------------------------------------------------------------

sub endAddCFn
{
	$endAddCFnCount++;

	&report('endAddCFn', $endAddCFnCount);

}	# End of endAddCFn.

#-----------------------------------------------------------------

sub endAddCNFn
{
	$endAddCNFnCount++;

	&report('endAddCNFn', $endAddCNFnCount);

}	# End of endAddCNFn.

#-----------------------------------------------------------------

sub endAddOFn
{
	$endAddOFnCount++;

	&report('endAddOFn', $endAddOFnCount);

}	# End of endAddOFn.

#-----------------------------------------------------------------

sub endAddOUFn
{
	$endAddOUFnCount++;

	&report('endAddOUFn', $endAddOUFnCount);

}	# End of endAddOUFn.

#-----------------------------------------------------------------

sub endDeleteCFn
{
	$endDeleteCFnCount++;

	&report('endDeleteCFn', $endDeleteCFnCount);

}	# End of endDeleteCFn.

#-----------------------------------------------------------------

sub endDeleteCNFn
{
	$endDeleteCNFnCount++;

	&report('endDeleteCNFn', $endDeleteCNFnCount);

}	# End of endDeleteCNFn.

#-----------------------------------------------------------------

sub endDeleteOFn
{
	$endDeleteOFnCount++;

	&report('endDeleteOFn', $endDeleteOFnCount);

}	# End of endDeleteOFn.

#-----------------------------------------------------------------

sub endDeleteOUFn
{
	$endDeleteOUFnCount++;

	&report('endDeleteOUFn', $endDeleteOUFnCount);

}	# End of endDeleteOUFn.

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

	$addCDNFnCount          = 0;
	$addCFnCount            = 0;
	$addCNAttributesFnCount = 0;
	$addCNDNFnCount         = 0;
	$addCNFnCount           = 0;
	$addCNSurnameFnCount    = 0;
	$addODNFnCount          = 0;
	$addOFnCount            = 0;
	$addOUDNFnCount         = 0;
	$addOUFnCount           = 0;
	$dateFnCount            = 0;
	$deleteCDNFnCount       = 0;
	$deleteCFnCount         = 0;
	$deleteCNDNFnCount      = 0;
	$deleteCNFnCount        = 0;
	$deleteODNFnCount       = 0;
	$deleteOFnCount         = 0;
	$deleteOUDNFnCount      = 0;
	$deleteOUFnCount        = 0;
	$endAddCFnCount         = 0;
	$endAddCNFnCount        = 0;
	$endAddOFnCount         = 0;
	$endAddOUFnCount        = 0;
	$endDeleteCFnCount      = 0;
	$endDeleteCNFnCount     = 0;
	$endDeleteOFnCount      = 0;
	$endDeleteOUFnCount     = 0;
	$endHeaderFnCount       = 0;
	$headerFnCount          = 0;

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

