#! /bin/bash

# Ping a domain 20 times, show both the 5 longest pings
# and the 5 shortest pings.

clear 
echo
echo "***************************************************************"
echo "***************************************************************"
echo "***                                                         ***"
echo "***              Ping a domain name 20 times.               ***"
echo "***                                                         ***"
echo "***       Output the five fastest and slowest pings.        ***"
echo "***                                                         ***"
echo "***************************************************************"
echo "***************************************************************"
echo

if [ $# -ne 1 ] # If there is not 1 argument supplied at command line, disply error.
then
	# print to error channel.
	echo "${0}: ERROR 1: Illegal number of arguments provided, script will terminate." 1>&2 
	echo "USAGE: ./${0} website.domain" # ${0##*/} outputs current scriptname.
	echo
	exit 1 # Exit program with general error exit code.
else
	ping -c 20 $1 2>/dev/null >pings.txt 
	# ping $1 20 times. Dump errors to /dev/null. Save ping output to pings.txt 
	# ping -c 20 -> -c = Ping only a certain number of times, 20 = ping 20 times.
	
	pingExitCode=$? # Get ping exit status.
			
	if [ $pingExitCode -eq 2 ] # # ping exit status 2 is 'Failed to initialize.'
	then
		echo "Failed to ping $1." 
		echo "Check your network firewall settings and/or internet connectivity." 
	else
		echo "The five fastest ping times:"
		cat pings.txt | grep -Eo 'time=[0-9]{2}\.[0-9]{1,2}' | cut -d'=' -f2 | awk ' {print $1}' | sort -n | head -5
		# Cat opens pings.text.
		# grep finds pattern 'time=10.01'. grep -Eo -> E = extended regex, o = only matching..
		# cut removes line preced by =
		# awk prints remaining text.
		# sort sorts by lowest times. sort -n -> n = highest values.
		# head deletes everything but 5 fastest times.
		echo
		echo
		echo "The five slowest ping times:"
		cat pings.txt | grep -Eo 'time=[0-9]{2}\.[0-9]{1,2}' | cut -d'=' -f2 | awk ' {print $1}' | sort -nr | head -5
		# Cat opens pings.text.
		# grep finds pattern 'time=10.01'. grep -Eo -> E = extended regex, o = only matching..
		# cut removes line preced by =
		# awk prints remaining text.
		# sort sorts by lowest times. sort -nr -> nr = highest values.
		# head deletes everything but 5 fastest times.
		echo
		echo
	fi
fi

exit 0 # Exit program with successful program run exit code.
