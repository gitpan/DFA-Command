#!/usr/gnu/bin/perl -w
#
# Name:
#	validate.pl.
#
# Purpose:
#	Validate a script generated from state machine data, as much as possible.
#
# Usage:
#	...>perl Validate.pl File.stt FirstEvent Script.pl
#
# Version:
#	1.0.1	24-Sep-96	Ron Savage
#
#-------------------------------------------------------------------

# Initialize.

use integer;

use DFA::Command;
use Getopt::Simple;

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

if (! getOptions($default, "Usage: Validate.pl [options] STTFileName FirstEvent DFAScriptFileName", 1) )
{
	exit(0);	# Failure.
}

$sttFileName	= shift;
$firstEvent		= shift;
$scriptFileName = shift;

$stateMachine = new DFA::Command($firstEvent);
# or
#$stateMachine = DFA::Command -> new($firstEvent);

$stateMachine -> load($sttFileName);

if ($$switch{'debug'})
{
	print '-' x 32, "\nStart of state transition table. \n", '-' x 32, "\n\n";

	$stateMachine -> dump();

	print '-' x 30, "\nEnd of state transition table. \n", '-' x 30, "\n\n";
}

$stateMachine -> validate($scriptFileName);

