#!/usr/gnu/bin/perl -w
#
# Name:
#	X500DN_Gen.pl.
#
# Purpose:
#	Exercise the DFA::Generate module.
#
# Usage:
#	...>perl X500DN_Gen.pl X500DN.stt headerEvent > X500DN.pl
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

