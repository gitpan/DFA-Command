# -*- perl -*-

use strict;

use vars qw($loaded);

BEGIN
{
	$| = 1;
	print "1..2\n";
}

END
{
	print "not ok 1\n" if (! $loaded);
}

use DFA::Command;

$loaded = 1;

print "ok 1\n";

my($testNum) = 1;

sub Test($)
{
	my($result) = shift;
	$testNum++;
	print ( ($result ? "" : "not "), "ok $testNum\n");
	$result;
}

my($fsm) = DFA::Command -> new();

Test($fsm); # or print "Error...\n";
