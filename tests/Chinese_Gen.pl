#!/usr/gnu/bin/perl -w
#
# Name:
#	Chinese_Gen.pl.
#
# Purpose:
#	Exercise the DFA::Generate module.
#
# Usage:
#	...>perl Chinese_Gen.pl Chinese.stt ChineseEvent > Chinese.pl
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

