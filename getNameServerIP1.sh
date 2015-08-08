#! /bin/bash

# Take a domain name as command line 
# and output it's ip addresses and hostnames of nameserver(s)

#clear # Clear screen
echo
echo "*******************************************************************" 
echo "*******************************************************************" 
echo "***                                                             ***"
echo "***       Take a domain name as a command line argument         ***"
echo "***  and isolate the hostnames of nameserver(s) from output of  ***"
echo "*** whois command and then IP addresses for each nameserver(s). ***"
echo "***                                                             ***"
echo "***     The program will work for com, net, edu, org, ie & uk   ***"
echo "***        domains avaialable from whois databases.             ***"
echo "***                                                             ***"
echo "*******************************************************************" 
echo "*******************************************************************"
echo

if [ $# -ne 1 ] # If there is not 1 argument supplied at command line, disply error.
then
	echo "${0}: ERROR 1: Illegal number of arguments provided, script will terminate." 1>&2 # print to error channel.
	echo "USAGE: ${0} website.domain" 
	echo
	echo "${0}: Script will be aborted." 
	echo
	exit 1 # Exit program with general error exit code.
else # whois -H removes legal notices from lookup. Dump errors into /dev/null. Save output to whoisOutput.txt
	whois -H $1 2>/dev/null >whoisOutput.txt 
	whoisExitCode=$? # $whoExitCode = exit status of last shell command.
		
	if [ $whoisExitCode -eq 2 ] # If whois command does not complete successfully, exit program.
	then			   # whois exit status 2 = Failed to initialize.	
		echo "${0}: ERROR 2: No whois server for." 1>&2 # print to error channel. 
		echo "Check your network firewall settings and/or internet connectivity." 
		echo
		echo "${0}: Script will be aborted." 
		echo
		exit 1 # Exit program with general error exit code.
	elif cat whoisOutput.txt | grep -o 'No whois server' >/dev/null # If domain does not exist or unavailable from a whois server.
	then					     # whois exit status 1 = General Error.
		incorrectDomainName=~$(echo $1 | grep -Eo '\.[[:alpha:].]{2,6}')
		# Get domain name name from $2 and save $incorrectDomainName
		echo "${0}: ERROR 3: No whois server for $incorrectDomainName domain." 1>&2 # print to error channel. 
		echo "Double check your spelling." 
		echo
		echo "${0}: Script will be aborted." 
		echo
		exit 1 # Exit program with general error exit code.
	elif cat whoisOutput.txt | grep -Eo 'No match for|Not Registered' >/dev/null # Dump program output to /dev/null
	then
		echo "${0}: ERROR 4: $1 does not exist." 1>&2 # print to error channel.
		echo
		echo "${0}: The program will be aborted." 
		echo
		exit 1 # Exit program with general error exit code.
	else
		cat whoisOutput.txt | awk '/[Nn]ame [Ss]erver|nserver/,/^$/ { print }' | sed '/URL of the ICANN/d' | grep -Eio '([[:alnum:]_.-]+?\.[[:alpha:].]{2,6})' >hostnames.text
	
		# cat opens whoisOutput.txt
		# awk will extract all lines that contains N(n)ame S(s)erver or nserver and stops at next blank line. 
		# sed will delete trailing line from .com whois lookups to prevent grep capturing final domain name in icann notice.  
		# Grep will extract URL with up to 2 level domain names i.e .co.uk
		# grep -Eio -> E= extended regex, i= ignore case, o= only matching.
		# Save to hostnames.text
		# The line above will extract nameserver shostnames from all whois lookups.
		
		echo "IP address and hostname(s) of nameserver(s) for $1"
		echo
		echo
		
		cat hostnames.text | while read LINE # Open hostnames.text and read it one line at a time.
		do
			# Run ping -c 1 $LINE and save output to $hostnamePing. Dump errors into /dev/null
			# ping -c 1 -> -c = count i.e. no. of pings, 1 = number of pings.
			hostnamePing=$(ping -c 1 $LINE 2>/dev/null) 
			pingExitCode=$?
			
			if [ $pingExitCode -eq 2 ] # # ping exit status 2 is 'Failed to initialize.'
			then
				echo "Failed to ping $LINE. Check your network firewall settings and/or internet connectivity." 
			else
				echo "Hostname: $LINE     IP Address: `echo $hostnamePing | awk '/PING/ { print }' | cut  -d')' -f1 | cut -d'(' -f2 ` " 2>/dev/null
				
				# Print hostname and IP address. ping once each URL from file. 
				# echo will pipe current line hostnames.text.
				# awk will extract line beginning with PING. 
				# cut will extract IP addresses delimited by a brackets.
			fi	
		done <hostnames.text # close hostnames.text
	fi
fi
exit 0 # Exit program with successful program run exit code.
