#!/usr/gnu/bin/perl -w
#
# Name:
#	Gen_Test_2.pl.
#
# Purpose:
#	Exercise the DFA::Generate module.
#
# Warning:
#	Do not overwrite Test_2.pl, since it contains extra code.
#
# Usage:
#	...>perl Test_2_Gen.pl Test.STT headerEvent > Test_2_careful.pl
#
# Version:
#	1.00	11-Apr-97	Ron Savage	rpsavage@ozemail.com.au
#-------------------------------------------------------------------

# Initialize.

use integer;
use strict;

use DFA::Generate;

$STTFileName	= shift;
$firstEvent		= shift;

#DFA::Generate -> generate($STTFileName, $firstEvent);

