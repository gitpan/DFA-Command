#!/usr/gnu/bin/perl -w

use ExtUtils::MakeMaker;

WriteMakefile
(
'clean'				=>
	{
	'FILES'			=> 'blib/* Makefile MANIFEST DFA-Command-*'
	},
'dist'				=>
	{
	'COMPRESS'		=> 'gzip',
	'SUFFIX'		=> 'gz'
	},
'DISTNAME'			=> 'DFA-Command',
'NAME'				=> 'DFA::Command',
'PM'				=>
	{
	'Command.pm' 	=> '$(INST_LIBDIR)/Command.pm',
	'Generate.pm' 	=> '$(INST_LIBDIR)/Generate.pm',
	},
'VERSION_FROM'		=> 'Command.pm'
);
