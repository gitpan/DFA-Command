use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile
(
	($] ge '5.005') ?
	(
		'AUTHOR' => 'Ron Savage (ron@savage.net.au)',
		'ABSTRACT' => 'Discrete Finite Automata/Finite State Machine',
    ) : (),
	clean			=>
	{
		FILES		=> 'blib/* Makefile MANIFEST DFA-Command-*'
	},
	dist			=>
	{
		COMPRESS	=> 'gzip',
		SUFFIX		=> 'gz'
	},
	DISTNAME		=> 'DFA-Command',
	NAME			=> 'DFA::Command',
	PL_FILES		=> {},
	PREREQ_PM		=>
	{
		Carp		=> 0,
		Test::More	=> 0,
		Test::Pod	=> 0,
	},
	VERSION_FROM	=> 'lib/DFA/Command.pm'
);
