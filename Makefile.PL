use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

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
'PREREQ_PM'			=> {},
'VERSION_FROM'		=> 'Command.pm'
);
