#!/usr/gnu/bin/perl -w
#
# Name:
#	Citizen_Gen.pl.
#
# Purpose:
#	Exercise the DFA::Generate module.
#
# Usage:
#	...>perl Citizen_Gen.pl Citizen.stt headerEvent > Citizen.pl
#
# Version:
#	1.00	11-Apr-97	Ron Savage	rpsavage@ozemail.com.au
#-------------------------------------------------------------------

# Initialize.

use integer;
use strict;

use DFA::Generate;

my($sttFileName)	= shift;
my($firstEvent)		= shift;

DFA::Generate -> generate($sttFileName, $firstEvent);

