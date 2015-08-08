#! /bin/bash

# Isolate IP address from output of command curl -s http://checkip.dyndns.org/

clear # Clear screen
echo
echo "**************************************************" 
echo "**************************************************" 
echo "***                                            ***"
echo "***        Isolate my IP address from,         ***"
echo "***     curl -s http://checkip.dyndns.org/     ***"
echo "***                                            ***"
echo "**************************************************" 
echo "**************************************************"
echo
echo

# Run curl -s http://checkip.dyndns.org/ and save output to $curlOutput. curl -s = silent mode, don't show progress bar. Dump error messages into /dev/null. 
curlOutput=$(curl -s http://checkip.dyndns.org/ 2>/dev/null) 

curlExitCode=$? # OUT = exit status of last shell command.

if [ $curlExitCode -ne 0 ] # Curl exit status 0 is 'Successful command completion'
then
	echo "${0}: ERROR 1: Curl command failed to execute correctly." 1>&2 # print to error channel.
	echo "Check your network firewall settings and/or inetrnet connectivity." 
	echo
	echo "${0}: Script will be aborted." 
	echo
	exit 1 # Exit program with general error exit code.
else
	echo "Output of curl -s 'http://checkip.dyndns.org/': "
	echo $curlOutput # Ouput full curl command output
	echo
	echo
	printf "Your IP address: `echo $curlOutput | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`"
	echo  # Print out ip address, grep -o = only disply matcing pattern, regex taken from class notes.
	echo
fi

exit 0 # Exit program with successful program run exit code.
