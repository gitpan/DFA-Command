DFA::Command.

This module implements a Discrete Finite Automata, ie a Finite State Machine.

The module reads a state transition table containing regular expressions to look
for in a data file. It then reads a data file looking for those REs.
When a RE is detected, a subroutine is called.

DFA::Generate.

This module reads a state transition table and generates a Perl
script which uses the module DFA::Command to process data according
to the said table.

There are 3 sets of test files:
1. For crude phrase-by-phrase translation of Chinese into English
2. For processing personnel data with various fields per citizen
3. For processing X.500 Distinguished Names

Each set contains 7 files. For the Chinese data these are:
1. Chinese_Gen.pl
	A Perl script generator which uses DFA::Generate to generate a Perl script
2. ChineseTest.pl
	A generated script. This is the one which does the real work
3. Chinese.stt
	A State Transition Table used by both the generator	script and the generated
	script
4. Chinese.pl
	A previously-generated Perl script to test the generator.
	Test using 'diff Chinese.pl ChineseTest.pl'.
	Note: These 2 files are different, because I generated Chinese.pl
	this way but then patched it to make it more interesting
5. Chinese.dat
	The data file input to the generated script, ie the real data
6. ChineseTest.log
	The output from ChineseTest.pl after processing Chinese.dat
7. Chinese.log
	The output from Chinese.pl after processing Chinese.dat

