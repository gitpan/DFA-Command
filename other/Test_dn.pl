#!/usr/gnu/bin/perl -w
#
# Name:
#	test_DN.pl.
#
# Purpose:
#	Exercise the X500::DN::Parser module.
#
# Abbreviations:
#	DN:  X.500 Distinguished Name.
#	RDN: X.500 Relative Distinguished Name.
#
# Usage:
#	Prompt>perl testDN.pl > testDN.log
#
# Version:
#	1.00	11-Jan-97	Ron Savage	rpsavage@ozemail.com.au
#-------------------------------------------------------------------

# Initialize.

use X500::DN::Parser;

$parser = new X500::DN::Parser(\&errorInDN);

# List the RDN components in the desired order.

#@RDNComponent = ('c', 'o', 'ou', 'cn');

#%RDNName =
#(
#	'c'		=> 'countryName',
#	'o'		=> 'organizationName',
#	'ou'	=> 'organizationalUnitName',
#	'cn'	=> 'commonName'	# Not commonNameName!
#);

&checkDN('', 'c');
&checkDN('c', 'c');
&checkDN('=', 'c');
&checkDN('c=', 'c');
&checkDN('c==', 'c');
&checkDN('c==au', 'c');
&checkDN('c=au=', 'c');
&checkDN('c=au;', 'c');
&checkDN('c=au;o', 'c', 'o');
&checkDN('c=au;o=', 'c', 'o');
&checkDN('c=au;o=MagicWare;', 'c', 'o');
&checkDN('c=au;l=Melbourne;o=MagicWare;ou=Research;c=Ron Savage',
	'c', 'l', 'o', 'ou', 'cn');

print "Locality: present. OrganizationalUnit: absent. \n";
&checkDN('c=au;l=Melbourne;o=MagicWare;cx=Ron Savage',
	'c', '[l]', 'o', '[ou]', 'cn');

print "Locality: present. OrganizationalUnit: present. \n";
&checkDN('c=au;l=Melbourne;o=MagicWare;ou=Research;cx=Ron Savage',
	'c', '[l]', 'o', '[ou]', 'cn');

print "Successes without locality. \n";
print '-' x 65, "\n";

&checkDN('c=au', 'c');
&checkDN('c=au;o=MagicWare', 'c', 'o');
&checkDN('c=au;o=MagicWare;ou=Research', 'c', 'o', 'ou');
&checkDN('c=au;o=MagicWare;ou=Research;cn=Ron Savage',
	'c', 'o', 'ou', 'cn');
&checkDN('c=au;o=MagicWare;cn=Ron Savage', 'c', 'o', 'cn');

print "Successes with locality. \n";
print '-' x 65, "\n";

&checkDN('c=au;l=Melbourne', 'c', 'l');
&checkDN('c=au;l=Melbourne;o=MagicWare', 'c', 'l', 'o');
&checkDN('c=au;l=Melbourne;o=MagicWare;ou=Research',
	'c', 'l', 'o', 'ou');

# The next 4 are a set.

print "Locality: absent. OrganizationalUnit: absent. \n";
&checkDN('c=au;o=MagicWare;cn=Ron Savage',
	'c', '[l]', 'o', '[ou]', 'cn');

print "Locality: absent. OrganizationalUnit: present. \n";
&checkDN('c=au;o=MagicWare;ou=Research;cn=Ron Savage',
	'c', '[l]', 'o', '[ou]', 'cn');

print "Locality: present. OrganizationalUnit: absent. \n";
&checkDN('c=au;l=Melbourne;o=MagicWare;cn=Ron Savage',
	'c', '[l]', 'o', '[ou]', 'cn');

print "Locality: present. OrganizationalUnit: present. \n";
&checkDN('c=au;l=Melbourne;o=MagicWare;ou=Research;cn=Ron Savage',
	'c', '[l]', 'o', '[ou]', 'cn');

exit(1);

#-------------------------------------------------------------------

sub checkDN
{
	my($testDN, @RDN) = @_;

	my($dn, $genericDN, %RDN) = $parser -> parse($testDN, @RDN);

	if (! defined($dn) )
	{
		print "\tError. \n";
	}
	else
	{
		print "DN: $dn. \nGeneric DN: $genericDN. \nComponents of the RDN:\n";

		my($key);

		for $key (keys(%RDN) )
		{
			print "$key: $RDN{$key}. \n";
		}
	}

	print '-' x 65, "\n";

}	# End of checkDN.

#-------------------------------------------------------------------

sub errorInDN
{
	($this, $explanation, $dn, $genericDN) = @_;

	$this = '';	# To stop a compiler warning.

	print "Invalid DN: <$dn>. \n<$explanation>. Expected format: " .
		"\n<$genericDN>\n";

}	 # End of errorInDN.

#-------------------------------------------------------------------
