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
#	1.00	11-Apr-97
#
# Author:
#	Ron Savage <ron@savage.net.au>
#	http://savage.net.au/index.html
#-------------------------------------------------------------------

# Initialize.

use strict;

use DFA::Generate;

my($sttFileName)	= shift;
my($firstEvent)		= shift;

DFA::Generate -> generate($sttFileName, $firstEvent);

