NAME
    "DFA::Command" - A Discrete Finite Automata command processor.

    "DFA::Generate" - A DFA program generator.

SYNOPSIS
            use DFA::Command;

            $stateMachine = new DFA::Command('Name of first event');
            # Or:
            #$stateMachine = DFA::Command -> new('Name of first event');

            $stateMachine -> load('Name of STT file');
            $stateMachine -> dump() if ($YouAreDebugging);

            $stateMachine -> process('Name of a event file');

DESCRIPTION
    "DFA::Command"

    This module reads a state transition table and then reads a data file
    looking for patterns as defined by regular expressions in the state
    transition table. When a transition is detected, a sub is called.

    "DFA::Generate"

    This module reads a state transition table and generates a Perl script
    which uses the module "DFA::Command" to process data according to the
    said table.

    These 2 modules are installed together.

    The name "DFA::Command" was chosen because:

    *   Somebody beat me to it. I wanted to use FSM (Finite State Machine)

    *   It creates an appropriate and convenient naming structure for
        related packages

    *   It installs easily in Unix, DOS and NT file systems

    *   It was developed in an environment where the input file contained
        commands and non-commands

INSTALLATION
    You install "DFA::Command", as you would install any perl module
    library, by running these commands:

            perl Makefile.PL
            make
            make test
            make install

    If you want to install a private copy of "DFA::Command" in your home
    directory, then you should try to produce the initial Makefile with
    something like this command:

            perl Makefile.PL LIB=~/perl
                    or
            perl Makefile.PL LIB=C:/Perl/Site/Lib

    If, like me, you don't have permission to write man pages into unix
    system directories, use:

            make pure_install

    instead of make install. This option is secreted in the middle of p 414
    of the second edition of the dromedary book.

FEATURES
    When input is recognised, and an action function is about to be called,
    "popEvent()" checks that the event just detected was one of those
    expected in the current state.

    Just after an action function is called, the names of those events
    expected next are saved by "pushEvent()", in preparation for the next
    call to popEvent(). This feature and the previous one add overhead to
    the code, but form a marvellous debugging aid.

TEST SCRIPTS
    This package contains 3 sets of test files:

    *   Chinese

    *   Citizen

    *   X500

    Each set of test files contains:

    *   A state transition table. These files are called: Chinese.STT,
        Citizen.STT and X500DN.STT.

    *   A data file comtaining commands to be recognized by the DFA. These
        files are called: Chinese.dat, Citizen.dat and X500DN.dat.

    *   A script (1) demonstrating DFA::Generate, which when run generates a
        script (2) demonstrating DFA::Command. These scripts (1) are called:
        Chinese_Gen.pl, Citizen_Gen.pl and X500DN_Gen.pl.

    *   A script (2) which is the output of the previous script (1). These
        scripts (2) are called: ChineseTest.pl, CitizenTest.pl and
        X500DNTest.pl.

    *   A script (3) which is a version of (2), ie which I have generated
        and then modified to demonstrate some possibilities. These scripts
        (3) are called: Chinese.pl, Citizen.pl and X500DN.pl.

    *   2 log files output by these 2 scripts (2, 3). These logs are called:
        ChineseTest.log, Chinese.log, CitizenTest.log, Citizen.log,
        X500DNTest.log, X500DN.log.

    These scripts are all in a subdirectory called test. They are not in a
    subdirectory called t because the test harness does not provide for
    scripts to be run which generate scripts to be run.

CONFIGURATION OPTIONS
    chomp. Chomp each input line before processing it. Default: True

    commentPrefix. Ignore any input lines which start with this character.
    If trimLeading is false, and a line starts with whitespace followed by
    this character, that line will still be ignored. Default: '#'

    ignoreBlankLines. If true, ignore input lines which are blank after any
    chomping. Default: True

    trimLeading. If true, trim leading whitespace from each input line
    before processing it. Default: True

    trimTrailing. If true, trim trailing whitespace from each input line
    before processing it. This takes place after any chomping. Default: True

WARNING
    Go to any lengths whatsoever to avoid '%' characters in your input,
    since some C compilers butcher such input. Eg: The thrice-cursed Pyramid
    C++ compiler.

FORMAT OF A STATE TRANSITION TABLE
    Typically, there will be several lines for each state. These lines will
    differ by their event names, and the corresponding regexp which
    recognises the given event.

    Each line consists of these fields:

    *   The name of the state. Use \w as your guideline for forming names -
        ie no whitespace

    *   The regexp to be used to search for an event in the input line. In
        colloquial terms, this means the regexp to be used to search for the
        presence of a command in the input line. The arrival of this command
        is the event in question. Don't use whitespace within the regexp,
        since these lines are split on whitespace. (No package is
        perfect...)

    *   The name of the event detected if the regexp fires. Use \w - ie no
        whitespace

    *   The name of the action function to call if the regexp fires

    *   The names of the events which are allowed to follow the current
        event. Separate event names with '|', without surrounding
        whitespace. Alternately, as syntactic sugar, use the special token
        commandList to refer to all events where the name of the state is
        'commandState'

Q & A
    How do I skip input text? Use a regexp of '.*' in your state transition
    table.

    If my input is 'abcd' and I have 2 regexps, 'abc.*' and 'abcd.*', which
    regexp fires? Hmmm. Grammatically speaking, that is a question.
    Seriously tho, the order of evaluation will be the order in which keys
    are stored in hashes, which is not under user control. In short, you
    bungled it by using ambiguous regexps.

DEREFERENCING GUIDELINES
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

PROCESSING of #if defined()
    Reference: PC Techniques, Aug/Sep 1993, p 102, Hax 166. Unimplemented.

WARNING re Perl bug
    As always, be aware that these 2 lines mean the same thing, sometimes:

    *   $self -> {'thing'}

    *   $self->{'thing'}

    The problem is the spaces around the ->. Inside double quotes, "...",
    the first space stops the dereference taking place. Outside double
    quotes the scanner correctly associates the $self token with the
    {'thing'} token.

    I regard this as a bug.

ACKNOWLEDGEMENTS
    The processing loop at the heart of this module is something I
    downloaded from comp.land.perl.misc circa 1994. I encourage the author
    to contact me.

    You'll know who you are: There were 2 bugs - both harmless - in 1 line
    of code, in the routine I call load(). Anybody who accepts
    responsibility for this code will be deemed to be the author. Well done!

AUTHOR
    "DFA::Command" and "DFA::Generate" were written by Ron Savage
    *<ron@savage.net.au>* in 1997.

LICENCE
    Australian copyright (c) 1997-2002 Ron Savage.

            All Programs of mine are 'OSI Certified Open Source Software';
            you can redistribute them and/or modify them under the terms of
            The Artistic License, a copy of which is available at:
            http://www.opensource.org/licenses/index.html
