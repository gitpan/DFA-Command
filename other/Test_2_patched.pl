#!/usr/gnu/bin/perl -w
#
# Name:
#	Test_2.pl.
#
# Purpose:
#	Exercise the DFA::Command module.
#
# Abbreviations:
#	DN:  X.500 Distinguished Name.
#	RDN: X.500 Relative Distinguished Name.
#
# Usage:
#	Prompt>perl Test_2.pl Test.STT headerEvent Test.dat > Test_2.log
#
# Version:
#	1.00	10-Apr-97	Ron Savage	rpsavage@ozemail.com.au
#-----------------------------------------------------------------

# Initialize.

use DFA::Command;
use Getopt::Simple;
use X500::DN::Parser;

my($default) =
{
'help' =>
	{
	'Type'		=> '',
	'Env'		=> '-',
	'Default'	=> '',
	'Order'		=> 1,
	},
'debug' =>
	{
	'Type'		=> '=s',
	'Env',		=> '-',
	'Default'	=> '',
	'Order'		=> 2,
	},
};

if (! getOptions($default, "Usage: Chinese.pl [options]", 1) )
{
	exit(0);	# Failure.
}

$STTFileName	= shift;
$firstEvent		= shift;

$stateMachine = new DFA::Command($firstEvent);
# or
#$stateMachine = DFA::Command -> new($firstEvent);

$parser = new X500::DN::Parser(\&errorInDN);

$stateMachine -> load($STTFileName);

if ($$switch{'debug'})
{
	print '-' x 32, "\nStart of state transition table. \n", '-' x 32, "\n\n";

	$stateMachine -> dump();

	print '-' x 30, "\nEnd of state transition table. \n", '-' x 30, "\n\n";
}

@DNOfCountry			= ('c');
@DNOfOrganization		= ('c', 'o');
@DNOfOrganizationalUnit	= ('c', 'o', 'ou');
@DNOfSubscriber			= ('c', 'o', '[ou]', 'cn');

# Process the one input file.

for $fileName (@ARGV)
{
	print '-' x 30, "\nStart of file: $fileName. \n", '-' x 30, "\n\n";

	&init1File();
	$stateMachine -> process($fileName);

	print '-' x 30, "\nEnd of file: $fileName. \n", '-' x 30, "\n\n";
}

exit(1);

#-----------------------------------------------------------------
#-----------------------------------------------------------------

sub addCDNFn
{
	$addCDNCount++;

	my($dn, $genericDN, %RDN) = $parser -> parse($stateMachine -> {'clean'}, @DNOfCountry);

	displayDN('addCDNFn', $addCCount, $dn, $genericDN);

}	# End of addCDNFn.

#-----------------------------------------------------------------

sub addCFn
{
	$addCCount++;

	print "addCFn: $addCCount. \n";

}	# End of addCFn.

#-----------------------------------------------------------------

sub addCNAttributesFn
{
	$addCNAttributesCount++;

	print "addCNAttributesFn: $addCNAttributesCount. \n";

}	# End of addCNAttributesFn.

#-----------------------------------------------------------------

sub addCNDNFn
{
	my($dn, $genericDN, %RDN) = $parser -> parse($stateMachine -> {'clean'}, @DNOfSubscriber);

	$addCNDNCount++;

	displayDN('addCNDNFn', $addCNCount, $dn, $genericDN);

}	# End of addCNDNFn.

#-----------------------------------------------------------------

sub addCNFn
{
	$addCNCount++;

	print "addCNFn: $addCNCount. \n";

}	# End of addCNFn.

#-----------------------------------------------------------------

sub addCNSurnameFn
{
	$addCNSurnameCount++;

# Parse the surname=<Text> line.

	@field = split(/=/, $stateMachine -> {'clean'});

	$stateMachine -> invalidData($fileName, '', $lineCount,
		'No surname specified')
		if ( ($#field == 0) || (length($field[1]) == 0) );

	push(@cnSurname, $field[1]);

	print "addCNSurnameFn: $addCNSurnameCount: Surname: $field[1]. \n";

}	# End of addCNSurnameFn.

#-----------------------------------------------------------------

sub addODNFn
{
	$addODNCount++;

	my($dn, $genericDN, %RDN) = $parser -> parse($stateMachine -> {'clean'}, @DNOfOrganization);

	displayDN('addODNFn', $addOCount, $dn, $genericDN);

}	# End of addODNFn.

#-----------------------------------------------------------------

sub addOFn
{
	$addOCount++;

	print "addOFn: $addOCount. \n";

}	# End of addOFn.

#-----------------------------------------------------------------

sub addOUDNFn
{
	$addOUDNCount++;

	my($dn, $genericDN, %RDN) = $parser -> parse($stateMachine -> {'clean'}, @DNOfOrganizationalUnit);

	displayDN('addOUDNFn', $addOUCount, $dn, $genericDN);

}	# End of addOUDNFn.

#-----------------------------------------------------------------

sub addOUFn
{
	$addOUCount++;

	print "addOUFn: $addOUCount. \n";

}	# End of addOUFn.

#-----------------------------------------------------------------

sub dateFn
{
	$dateCount++;

# Parse the date=<Text> line.

	@field = split(/=/, $stateMachine -> {'clean'});

	$stateMachine -> invalidData($fileName, '', -1, 'No date specified')
		if ( ($#field == 0) || (length($field[1]) == 0) );

	print "dateFn: $dateCount: $field[1]. \n";

}	# End of dateFn.

#-----------------------------------------------------------------

sub deleteCDNFn
{
	$deleteCDNCount++;

	my($dn, $genericDN, %RDN) = $parser -> parse($stateMachine -> {'clean'}, @DNOfCountry);

	displayDN('deleteCDNFn', $deleteCCount, $dn, $genericDN);

}	# End of deleteCDNFn.

#-----------------------------------------------------------------

sub deleteCFn
{
	$deleteCCount++;

	print "deleteCFn: $deleteCCount. \n";

}	# End of deleteCFn.

#-----------------------------------------------------------------

sub deleteCNDNFn
{
	$deleteCNDNCount++;

	my($dn, $genericDN, %RDN) = $parser -> parse($stateMachine -> {'clean'}, @DNOfSubscriber);

	displayDN('deleteCNDNFn', $deleteCNCount, $dn, $genericDN);

}	# End of deleteCNDNFn.

#-----------------------------------------------------------------

sub deleteCNFn
{
	$deleteCNCount++;

	print "deleteCNFn: $deleteCNCount. \n";

}	# End of deleteCNFn.

#-----------------------------------------------------------------

sub deleteODNFn
{
	$deleteODNCount++;

	my($dn, $genericDN, %RDN) = $parser -> parse($stateMachine -> {'clean'}, @DNOfOrganization);

	displayDN('deleteODNFn', $deleteOCount, $dn, $genericDN);

}	# End of deleteODNFn.

#-----------------------------------------------------------------

sub deleteOFn
{
	$deleteOCount++;

	print "deleteOFn: $deleteOCount. \n";

}	# End of deleteOFn.

#-----------------------------------------------------------------

sub deleteOUDNFn
{
	$deleteOUDNCount++;

	my($dn, $genericDN, %RDN) = $parser -> parse($stateMachine -> {'clean'}, @DNOfOrganizationalUnit);

	displayDN('deleteOUDNFn', $deleteOUCount, $dn, $genericDN);

}	# End of deleteOUDNFn.

#-----------------------------------------------------------------

sub deleteOUFn
{
	$deleteOUCount++;

	print "deleteOUFn: $deleteOUCount. \n";

}	# End of deleteOUFn.

#-----------------------------------------------------------------

sub displayDN
{
	my($fn, $count, $dn, $genericDN) = @_;

	print "$fn: $count. \n\tGeneric DN: $genericDN. \n\t        DN: $dn. \n";

}	# End of displayDN.

#-----------------------------------------------------------------

sub endAddCFn
{
	print "endAddCFn: $addCCount. \n\n";

}	# End of endAddCFn.

#-----------------------------------------------------------------

sub endAddCNFn
{
	my($cnSurname);

# Process the stacked surnames...

	$stateMachine -> invalidData($fileName, '', $lineCount,
		"'$stateMachine -> {'command'}' expects exactly 1 " .
		"'surname=' line") if ($#cnSurname != 0);

	$cnSurname	= $cnSurname[0];
	@cnSurname	= ();

	print "endAddCNFn: $addCNCount. \n\n";

}	# End of endAddCNFn.

#-----------------------------------------------------------------

sub endAddOFn
{
	print "endAddOFn: $addOCount. \n\n";

}	# End of endAddOFn.

#-----------------------------------------------------------------

sub endAddOUFn
{
	print "endAddOUFn: $addOUCount. \n\n";

}	# End of endAddOUFn.

#-----------------------------------------------------------------

sub endDeleteCFn
{
	print "endDeleteCFn: $deleteCCount. \n\n";

}	# End of endDeleteCFn.

#-----------------------------------------------------------------

sub endDeleteCNFn
{
	print "endDeleteCNFn: $deleteCNCount. \n\n";

}	# End of endDeleteCNFn.

#-----------------------------------------------------------------

sub endDeleteOFn
{
	print "endDeleteOFn: $deleteOCount. \n\n";

}	# End of endDeleteOFn.

#-----------------------------------------------------------------

sub endDeleteOUFn
{
	print "endDeleteOUFn: $deleteOUCount. \n\n";

}	# End of endDeleteOUFn.

#-----------------------------------------------------------------

sub endHeaderFn
{
	print "endHeaderFn: $headerCount. \n\n";

}	# End of endHeaderFn.

#-----------------------------------------------------------------

sub errorInDN
{
	($this, $explanation, $dn, $genericDN) = @_;

	$this = '';	# To stop a compiler warning.

	print "Invalid DN: <$dn>. \n<$explanation>. Expected format: " .
		"\n<$genericDN>\n";

}	 # End of errorInDN.

#-----------------------------------------------------------------

sub headerFn
{
	$headerCount++;

	print "headerFn: $headerCount. \n";

}	# End of headerFn.

#-----------------------------------------------------------------

sub init1File
{

	$addCCount            = 0;
	$addCDNCount          = 0;
	$addCNAttributesCount = 0;
	$addCNCount           = 0;
	$addCNDNCount         = 0;
	$addCNSurnameCount    = 0;
	$addOCount            = 0;
	$addODNCount          = 0;
	$addOUCount           = 0;
	$addOUDNCount         = 0;
	$dateCount            = 0;
	$deleteCCount         = 0;
	$deleteCDNCount       = 0;
	$deleteCNCount        = 0;
	$deleteCNDNCount      = 0;
	$deleteOCount         = 0;
	$deleteODNCount       = 0;
	$deleteOUCount        = 0;
	$deleteOUDNCount      = 0;
	$headerCount          = 0;

}	# End of init1File.

