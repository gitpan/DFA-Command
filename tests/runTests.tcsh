#!/bin/tcsh
#
# Name:
#	runTests.bat.

cd .

perl Chinese_Gen.pl Chinese.stt StartEvent             > ChineseTest.pl
perl ChineseTest.pl Chinese.stt StartEvent Chinese.dat > ChineseTest.log
echo Log from generated program ChineseTest.pl:
cat ChineseTest.log
echo ------------------------------------
perl Chinese.pl     Chinese.stt StartEvent Chinese.dat > Chinese.log
echo Log from generated and edited program Chinese.pl:
cat Chinese.log

echo ------------------------------------
echo ------------------------------------

perl Citizen_Gen.pl Citizen.stt headerEvent             > CitizenTest.pl
perl CitizenTest.pl Citizen.stt headerEvent Citizen.dat > CitizenTest.log
echo Log from generated program CitizenTest.pl:
cat CitizenTest.log
echo ------------------------------------
perl Citizen.pl     Citizen.stt headerEvent Citizen.dat > Citizen.log
echo Log from generated and edited program Citizen.pl:
cat Citizen.log

echo ------------------------------------
echo ------------------------------------

perl X500DN_Gen.pl X500DN.stt headerEvent            > X500DNTest.pl
perl X500DNTest.pl X500DN.stt headerEvent X500DN.dat > X500DNTest.log
echo Log from generated program X500DNTest.pl:
cat X500DNTest.log
echo ------------------------------------
perl X500DN.pl     X500DN.stt headerEvent X500DN.dat > X500DN.log
echo Log from generated and edited program X500DN.pl:
cat X500DN.log
