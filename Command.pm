package DFA::Command;

use integer;
use strict;
no strict 'refs';

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;

@ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

@EXPORT		= qw(load new process);

@EXPORT_OK	= qw(dump validate);

$VERSION	= '1.92';

# Preloaded methods go here.
#-------------------------------------------------------------------

# Clean up the input line.

sub clean
{
	my($self, $line) = @_;

	print "Entered Command::clean(). \n" if ($self -> {'debug'});

	chomp($line) if ($self -> {'chomp'});

	$line =~ s/^\s+(.*)/$1/ if ($self -> {'trimLeading'});
	$line =~ s/(.*)\s+$/$1/ if ($self -> {'trimTrailing'});
	$line = '' if ($line =~ /^\s*($self->{'commentPrefix'})/);

	print "Leaving Command::clean(). \n" if ($self -> {'debug'});

	$line;

}	# End of clean.

#-------------------------------------------------------------------

# Print out the state transition table.

sub dump
{
	my($self) = @_;

	my($stateCount, $state, $i, $maxLength, $RE, $event) = (0, '', 0, 0, '', '');

	for $state (sort(keys(%{$self}) ) )
	{
		next if (ref($self -> {$state}) ne 'HASH');

		$stateCount++;

		print "State: $stateCount. $state. \n";

		$maxLength = 0;

		for ($i = 0; $i <= $#{$self -> {$state}{'RE'} }; $i++)
		{
			$RE			= ${$self -> {$state}{'RE'} }[$i];
			$maxLength	= length($RE) if (length($RE) > $maxLength);
		}

		$maxLength = 6 if ($maxLength < 6);

		print 'RE', ' ' x $maxLength, "Event\n";

		for ($i = 0; $i <= $#{$self -> {$state}{'RE'} }; $i++)
		{
			$RE		= ${$self -> {$state}{'RE'} }[$i];
			$event	= ${$self -> {$state}{'event'} }[$i];
			print $RE, ' ' x (2 + $maxLength - length($RE) ), "$event\n";
		}

		print "\n";

		my($eventCount) = 0;

		for $event (sort(keys(%{$self -> {$state} }) ) )
		{
			next if (ref($self -> {$state}{$event}) ne 'HASH');

			$eventCount++;

			print "State:      $stateCount. $state. Event: $eventCount. $event. \n";
			print "Subroutine: $self->{$state}{$event}{'sub'}(). " .
					"Next state: $self->{$state}{$event}{'nextState'}. \n\n";
		}
	}

}	# End of dump.

#-------------------------------------------------------------------

# Scan 1 line of input, looking for text which matches
# the definition of an event. After recognition of
# an event, a state transition can take place.

sub findEvent
{
	my($self, $fileName, $inputLine, $lineCount) = @_;

	print "Entered Command::findEvent(). \n" if ($self -> {'debug'});

	my($state)		= $self -> {'state'};
	my($event)		= $self -> {'event'};
	my($command)	= $self -> {'command'};

	my($testState, $i);

# Loop over all possible states.

	for $testState (keys(%$self) )
	{

		next if (ref($self -> {$testState}) ne 'HASH');

# Is $testState in fact the current state?

		if ($state eq $testState)
		{
			my($localRE, $localEvent);

# Loop over all possible REs associated with the current state.

			for ($i = 0;
				$i <= $#{$self -> {$state}{'RE'} };
				$i++)
			{

				$localRE		= ${$self -> {$state}{'RE'} }[$i];
				$localEvent		= ${$self -> {$state}{'event'} }[$i];

# Does the current input line match a RE belonging to
# the current state? If so, return the corresponding event.

				if ($inputLine =~ /$localRE/)
				{
					$self -> {'event'}	= $localEvent;
					$self -> {'$`'}		= $`;
					$self -> {'$&'}		= $&;
					$self -> {q/$'/}	= $';
					$self -> {'$1'}		= $1;	# $1 may be undef.
					$self -> {'$2'}		= $2;	# $2 may be undef.
					$self -> {'$3'}		= $3;	# $3 may be undef.

# Save the RE (minus any '^' prefix and '$' suffix).

					if ($localRE =~ /^([\^]?)(.+?)([\$]?)$/)
					{
						$localRE = $2;
					}

# Is the current state one of the command states? If so, save the
# RE as the name of the current command. Ditto if it's an *Entry state.

					if ($state =~ /^command/)
					{
						$command = $localRE;
					}

					$self -> {'command'}	= $command;
					$self -> {'RE'}			= $localRE;

# Return 1 so the caller can keep looping. This means more than 1 transition
# can take place on the basis of the text on a single input line.

					return 1;
				}
			}
		}
	}

# Input file error. This current line, $inputLine, does not contain a
# pattern which matches any of the regular expressions for the
# current state.

# Deimplement this call so the caller can continue.
# Anyway, the message output is not very meaningful when the list of
# valid events expected is empty.

##	$self -> invalidEvent($fileName, $inputLine, $lineCount,
##		$self -> {$state}{$event}{'validEvents'});

# Deimplement this call so the caller can continue.

#	$self -> invalidData($fileName, $inputLine, $lineCount,
#		"Current state: $self->{'state'}");

# Return 0 so the caller can stop looping.

	print "Leaving Command::findEvent(). \n" if ($self -> {'debug'});

	return 0;

}	# End of findEvent.

#-------------------------------------------------------------------

# Process the event detected in the input.

sub handleEvent
{
	my($self, $fileName, $inputLine, $lineCount) = @_;

	print "Entered Command::handleEvent(). \n" if ($self -> {'debug'});

	my($state)		= $self -> {'state'};
	my($event)		= $self -> {'event'};
	my($command)	= $self -> {'command'};

	my($nextState, $routine, $status);

	if (ref($self -> {$state}{$event}) )
	{
		$nextState	= $self -> {$state}{$event}{'nextState'};
		$routine	= $self -> {$state}{$event}{'sub'};
		$self -> popEvent($fileName, $inputLine, $lineCount);
		$status = eval("&$routine()");
		die $@ if $@;
		push(@{$self -> {'nextEvent'} }, $self -> {$state}{$event}{'validEvents'});
	}
	else
	{
		$status		= 0;
		$nextState	= $state;
	}

	print "Leaving Command::handleEvent(). \n" if ($self -> {'debug'});

	$self -> {'state'} = $nextState;

}	# End of handleEvent.

#-------------------------------------------------------------------

# Print out something when invalid data is detected.

sub invalidData
{
	my($self, $fileName, $inputLine, $lineCount, $message) = @_;

	if ($fileName ne '')
	{
		print "Error in input file: $fileName \@ line $lineCount. \n";
		print "Unexpected text: $inputLine. \n" if ($inputLine ne '');
	}

	print "$message. \n";

	exit(0);

}	# End of invalidData.

#-------------------------------------------------------------------

# Print out something when an invalid event is detected.

sub invalidEvent
{
	my($self, $fileName, $inputLine, $lineCount, $expectedEvent) = @_;

	my($state)		= $self -> {'state'};
	my($command)	= $self -> {'command'};

# Loop over all possible events associated with the current state.

	my($i, $localEvent, @localRE) = (0, '', () );

	for ($i = 0; $i <= $#{$self -> {'event'}{$state} }; $i++)
	{
		$localEvent = ${$self -> {'event'}{$state} }[$i];

# Skip to next if it's not one of the expected events for this state.

		next if ($expectedEvent !~ /$localEvent/);

# Found a match. Get the corresponding regular expression.
# This tells us what we're expecting at this point.

		push(@localRE, ${$self -> {'RE'}{$state} }[$i]);
	}

# Is $expectedEvent expected in the current state?

	if ($#localRE < 0)
	{

# No. Programming error. Panic. Luckily, this is impossible...

		$self -> invalidData($fileName, $inputLine, $lineCount,
			"The command '$command' does not expect '$expectedEvent' " .
			"at this point");
	}
	else
	{

# Yes. Save the RE (minus any '^' prefix and '$' suffix)
# as the currently expected command.

		@localRE = grep(s/^([\^]?)(.+?)([\$]?)$/$2/e, @localRE);

		$i = ($#localRE == 0) ? '' : "\n";

		$self -> invalidData($fileName, $inputLine, $lineCount,
			"The command '$command' expects $i'" .
			join("' or '", @localRE) . "' at this point");
	}

}	# End of invalidEvent.

#-------------------------------------------------------------------

# Load the state transition table from a file.

sub load
{
	my($self, $fileName) = @_;

	my($state, $RE, $event, $sub, $nextState, $validEvents);
	my($line, $lastState, @RE, @event);

	$lastState = '';

	@RE		= ();
	@event	= ();

	open(INX, $fileName) || die "Unable to open $fileName: \n";

	while (defined($line = <INX>) )
	{
		chomp($line);
		next if ($line =~ /\s*#/);
		next if (length($line) == 0);

# We assume the line contains these 6 fields:
# 0		1		2		3			4			5[|5]*
# state	RE		event	subroutine	nextState	validEvents

		($state, $RE, $event, $sub, $nextState, $validEvents) = split(/\s+/, $line);

		$self -> invalidData('', '', 0, "Not enough fields on this " .
			"line: \n$line") if (! defined($validEvents) );

		$self -> invalidData('', '', 0, "Duplicate data. State: $state. " .
			"Event: $event.\n$line") if (defined($self -> {$state}{$event}) );

		$self -> {$state}{$event}{'sub'}			= "::$sub";
		$self -> {$state}{$event}{'nextState'}		= $nextState;
		$self -> {$state}{$event}{'validEvents'}	= $validEvents;

		if ($state eq $lastState)
		{
			push(@RE, $RE);
			push(@event, $event);
		}
		else
		{
			if ($lastState ne '')
			{
				$self -> {$lastState}{'RE'}		= [@RE];
				$self -> {$lastState}{'event'}	= [@event];
				undef @RE;
				undef @event;
			}

			push(@RE, $RE);
			push(@event, $event);
			$lastState = $state;
		}
	}

	close(INX);

	$self -> {$lastState}{'RE'}		= [@RE];
	$self -> {$lastState}{'event'}	= [@event];

# Now, clean up the abbreviation 'commandList' in the data.

	my($commandList) =
		join('|', @{$self -> {'commandState'}{'event'} });

	$commandList .= '|EOFEvent';

# Loop over all possible validEvents.

	for $state (keys(%{$self}) )
	{
		next if (ref($self -> {$state}) ne 'HASH');

		for $event (keys(%{$self -> {$state} }) )
		{
			next if (ref($self -> {$state}{$event}) ne 'HASH');

# Does this combination have the abbreviation in it?

			if ($self->{$state}{$event}{'validEvents'} eq 'commandList')
			{
				$self -> {$state}{$event}{'validEvents'} = $commandList;
			}
		}
	}

}	# End of load.

#-------------------------------------------------------------------

# Fabricate a new object.

sub new
{
	my($class, $firstEvent)	= @_;

	my($self) = {};

	$self -> {'chomp'}				= 1;
	$self -> {'command'}			= 'initialCommand';
	$self -> {'commentPrefix'}		= '#';
	$self -> {'debug'}				= 0;
	$self -> {'event'}				= '';
	$self -> {'ignoreBlankLines'}	= 1;
	$self -> {'nextEvent'}			= [];
	$self -> {'RE'}					= '';
	$self -> {'state'}				= 'initialState';
	$self -> {'trimLeading'}		= 1;
	$self -> {'trimTrailing'}		= 1;

	push(@{$self -> {'nextEvent'} }, $firstEvent);

	return bless $self, $class;

}	# End of new.

#-------------------------------------------------------------------

# Pop the stack containing events expected in the current state.

sub popEvent
{
	my($self, $fileName, $inputLine, $lineCount) = @_;

	print "Entered Command::popEvent(). \n" if ($self -> {'debug'});

	my($state)		= $self -> {'state'};
	my($event)		= $self -> {'event'};
	my($command)	= $self -> {'command'};

# Test # 1. Did we get here without a call to pushEvent()?

	if ($#{$self -> {'nextEvent'} } < 0)
	{

# Yes. Programming error. Panic. Luckily, this is impossible...

		$self -> invalidData($fileName, '', $lineCount,
			'No commands were found in the input file');
	}

	my($expectedEvent) = pop(@{$self -> {'nextEvent'} });

# Test # 2. Is the current event one of the expected events?

	if ($expectedEvent !~ /$event/)
	{

# No. Loop over all possible events associated with the current state.

		$self -> invalidEvent($fileName, '', $lineCount, $expectedEvent);
	}

	print "Leaving Command::popEvent(). \n" if ($self -> {'debug'});

}	# End of popEvent.

#-----------------------------------------------------------------

# Process the user's file of real, live, data.

sub process
{
	my($self, $fileName) = @_;

	print "Entered Command::process(). \n" if ($self -> {'debug'});

	my($originalLine, $cleanLine);

	open(INX, $fileName) || die "Unable to open $fileName: \n";

	while (defined($originalLine = <INX>) )
	{
		$cleanLine = $self -> clean($originalLine);

		next if (length($cleanLine) == 0);

		chomp($originalLine);

		$self -> {'original'}	= $originalLine;
		$self -> {'clean'}		= $cleanLine;

		while ($self -> findEvent($fileName, $cleanLine, $.) )
		{
			$self -> handleEvent($fileName, $cleanLine, $.);
			$cleanLine = $self -> {q/$'/};
		}

	}	# End of while.
	
	$self -> {'event'} = 'EOFEvent';
	$self -> popEvent($fileName, '', $.);

# Put the close after the previous line, which uses $..

	close(INX);

	print "Leaving Command::process(). \n" if ($self -> {'debug'});

}	# End of process.

#-------------------------------------------------------------------

# Validate the script generated or edited by comparing bits of it
# with the state transition table.

sub validate
{
	my($self, $fileName) = @_;

# Read the script to be validated.

	my(%sub) = ();

	open(INX, $fileName) || die "Can't open $fileName: $! \n";

	while (<INX>)
	{
		chomp;

# Save the names of all subroutines seen in the source.

		$sub{"::$1"}++ if (/^sub (.+)$/);
	}

	close(INX);

# Validate the script.

	my($state, $event, $sub, $nextState, $validEvents, $validEvent);

	for $state (keys(%$self) )
	{
		next if (ref($self -> {$state}) ne 'HASH');

		for $event (keys(%{$self -> {$state} }) )
		{
			next if (ref($self -> {$state} -> {$event}) ne 'HASH');

# Test # 1.
# Is the subroutine actually in the script?

			$sub = $self -> {$state} -> {$event} -> {'sub'};

			print "Subroutine: $sub not present. \n"
				if (! defined($sub{$sub}) );

# Test # 2.
# Is the nextState actually in the STT?

			$nextState = $self -> {$state} -> {$event} -> {'nextState'};

			print "State: $nextState not present. \n"
				if (! defined($self -> {$nextState}) );

# Test # 3.
# Are the validEvents actually in the STT?

			$validEvents = $self -> {$state} -> {$event} -> {'validEvents'};

			for $validEvent (split(/\|/, $validEvents) )
			{
				next if ($validEvent eq 'EOFEvent');

				print "Valid event: $validEvent not present. \n"
					if (! defined($self -> {$nextState} -> {$validEvent}) );
			}
		}
	}

}	# End of validate.

#-------------------------------------------------------------------

# Autoload methods go after =cut, and are processed by the autosplit program.

1;

__END__

=head1 NAME

DFA::Command - A Discrete Finite Automata command processor.

DFA::Generate - A DFA program generator.

=head1 SYNOPSIS

	use DFA::Command;

	$stateMachine = new DFA::Command('Name of first event');
	# Or:
	#$stateMachine = DFA::Command -> new('Name of first event');

	$stateMachine -> load('Name of STT file');
	$stateMachine -> dump() if ($YouAreDebugging);

	$stateMachine -> process('Name of a event file');

=head1 DESCRIPTION

DFA::Command.

This module reads a state transition table and then reads a data file
looking for patterns as defined by regular expressions in the state
transition table. When a transition is detected, a sub is called.

DFA::Generate.

This module reads a state transition table and generates a Perl
script which uses the module DFA::Command to process data according
to the said table.

The name DFA::Command was chosen because:

=over 4

=item *

Somebody beat me to it. I wanted to use FSM (Finite State Machine)

=item *

It creates an appropriate and convenient naming structure for related packages

=item *

It installs easily in Unix, DOS and NT file systems

=item *

It was developed in an environment where the input file contained commands
and non-commands

=back

=head1 FEATURES

When input is recognised, and an action function is about to be called,
C<popEvent()> checks that the event just detected was one of those expected
in the current state.

Just after an action function is called, the names of those events expected
next are saved by C<pushEvent()>, in preparation for the next call to
popEvent(). This feature and the previous one add overhead to the code,
but form a marvellous debugging aid.

=head1 TEST SCRIPTS

This package contains 3 sets of test files:

=over 4

=item *

Chinese

=item *

Citizen

=item *

X500

=back

Each set of test files contains:

=over 4

=item *

A state transition table.
	These files are called:
	Chinese.STT, Citizen.STT and X500DN.STT.

=item *

A data file comtaining commands to be recognized by the DFA.
	These files are called:
	Chinese.dat, Citizen.dat and X500DN.dat.

=item *

A script (1) demonstrating DFA::Generate, which when run generates a script (2)
	demonstrating DFA::Command.
	These scripts (1) are called:
	Chinese_Gen.pl, Citizen_Gen.pl and X500DN_Gen.pl.

=item *

A script (2) which is the output of the previous script (1).
	These scripts (2) are called:
	ChineseTest.pl, CitizenTest.pl and X500DNTest.pl.

=item *

A script (3) which is a version of (2), ie which I have generated and then modified
	to demonstrate some possibilities.
	These scripts (3) are called:
	Chinese.pl, Citizen.pl and X500DN.pl.

=item *

2 log files output by these 2 scripts (2, 3).
	These logs are called:
	ChineseTest.log, Chinese.log, CitizenTest.log, Citizen.log, X500DNTest.log,
	X500DN.log.

=back

These scripts are all in a subdirectory called test. They are not in a subdirectory
called t because the test harness does not provide for scripts to be run which
generate scripts to be run.

=head1 CONFIGURATION OPTIONS

chomp. Chomp each input line before processing it. Default: True

commentPrefix. Ignore any input lines which start with this character. If
trimLeading is false, and a line starts with whitespace followed by this
character, that line will still be ignored. Default: '#'

ignoreBlankLines. If true, ignore input lines which are blank after any chomping.
Default: True

trimLeading. If true, trim leading whitespace from each input line before
processing it. Default: True

trimTrailing. If true, trim trailing whitespace from each input line before
processing it. This takes place after any chomping. Default: True

=head1 WARNING

Go to any lengths whatsoever to avoid '%' characters in your input, since some
C compilers butcher such input. Eg: The thrice-cursed Pyramid C++ compiler.

=head1 FORMAT OF A STATE TRANSITION TABLE

Typically, there will be several lines for each state. These lines will differ by
their event names, and the corresponding regexp which recognises the given event.

Each line consists of these fields:

=over 4

=item *

The name of the state. Use \w as your guideline for forming names - ie no whitespace

=item *

The regexp to be used to search for an event in the input line. In colloquial
terms, this means the regexp to be used to search for the presence of a
command in the input line. The arrival of this command is the event in
question. Don't use whitespace within the regexp, since these lines are
split on whitespace. (No package is perfect...)

=item *

The name of the event detected if the regexp fires. Use \w - ie no whitespace

=item *

The name of the action function to call if the regexp fires

=item *

The names of the events which are allowed to follow the current event. Separate
event names with '|', without surrounding whitespace. Alternately, as syntactic
sugar, use the special token commandList to refer to all events where the name
of the state is 'commandState'

=back

=head1 Q & A

How do I skip input text? Use a regexp of '.*' in your state transition table.

If my input is 'abcd' and I have 2 regexps, 'abc.*' and 'abcd.*', which regexp
fires? Hmmm. Grammatically speaking, that is a question. Seriously tho, the
order of evaluation will be the order in which keys are stored in hashes,
which is not under user control. In short, you bungled it by using
ambiguous regexps.

=head1 DEREFERENCING GUIDELINES

	$self -> {$state} -> {$event} -> {'sub'}          Name of subroutine
	$self -> {$state} -> {$event} -> {'nextState'}    Name of state
	$self -> {$state} -> {$event} -> {'validEvents'}  Event|Event
	$self -> {$state} -> {'RE'}                       [REs]
	$self -> {$state} -> {'event'}                    [Events]
	$self -> {'nextEvent'}                            [Expected events]
	$self -> {'state'}                                Current state
	$self -> {'event'}                                Current event
	$self -> {'command'}                              Current command
	$self -> {'RE'}                                   Current RE
	$self -> {'original'}                             Current input line, original
	$self -> {'clean'}                                Current input line, cleaned up
	$self -> {'$1'}                                   Current text matching () IN RE
	$self -> {'$2'}                                   Current text matching () IN RE
	$self -> {'$3'}                                   Current text matching () IN RE

=head1 PROCESSING of #if defined()

Reference: PC Techniques, Aug/Sep 1993, p 102, Hax 166. Unimplemented.

=head1 WARNING re Perl bug

As always, be aware that these 2 lines mean the same thing, sometimes:

=over 4

=item *

$self -> {'thing'}

=item *

$self->{'thing'}

=back

The problem is the spaces around the ->. Inside double quotes, "...", the
first space stops the dereference taking place. Outside double quotes the
scanner correctly associates the $self token with the {'thing'} token.

I regard this as a bug.

=head1 AUTHOR

C<DFA::Command> and C<DFA::Generate> were written by Ron Savage
I<E<lt>rpsavage@ozemail.com.auE<gt>> in 1997.

=head1 ACKNOWLEDGEMENTS

The processing loop at the heart of this module is something I downloaded from
comp.land.perl.misc circa 1994. I encourage the author to contact me.

You'll know who you are: There were 2 bugs - both harmless - in 1 line of code,
in the routine I call load(). Anybody who accepts responsibility for this code
will be deemed to be the author. Well done!

=head1 LICENCE

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.
