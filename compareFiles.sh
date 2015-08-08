#! /bin/bash
# Take 2 file names as command line arguments, compare contents of the 2 files and delete 2nd file if they have the same contents.
# 

echo
echo "**************************************************" 
echo "**************************************************" 
echo "***                                            ***"
echo "***      Compare the contents of 2 files,      ***"
echo "***     and delete 2nd file if they match.     ***"
echo "***                                            ***"
echo "**************************************************" 
echo "**************************************************"
echo

OUT=$? # OUT = exit status of last shell command.

if [ $# -ne 2 ] # If there are not 2 arguments supplied at command line, disply error.
then
	echo "${0}: ERROR 1: Illegal number of arguments provided, script will terminate." 1>&2 # print to error channel.
	echo "USAGE: ${0} filename1 filename2" 
	echo
	echo "${0}: The program will be aborted." 
	echo
	exit 1 # Exit program with general error exit code.
else
	if [[ ! -f $1 ]] # Check that $1 file exists, if it does not, exit program.
	then 
		echo "${0}: ERROR 2: $1 does not exist." 1>&2 # print to error channel.
		echo
		echo "${0}: The program will be aborted." 
		echo
		exit 1 # Exit program with general error exit code.
	fi
	
	if [[ ! -f $2 ]] # Check that $2 file exists, if it does not, exit program..
	then
		echo "${0}: ERROR 3: $2 does not exist, script will terminate." 1>&2 # print to error channel.
		echo
		echo "${0}: The program will be aborted." 
		echo
		exit 1 # Exit program with general error exit code.
	else
		echo "Comapring contents of $1 and $2 to see if they match."
		echo
		echo "If they have the same contents $2 will be deleted."
		echo
		
		if cmp -s $1 $2 # Compare contents of the files, -s suppresses normal output. 
		then
			if ! rm $2 2>/dev/null # If script unable to delete $2, exit program.
			then
				echo "${0}: ERROR 4: Could not delete $2." 1>&2 # print to error channel.
				echo "Check 'write'permissions on $2."
				echo
				echo "${0}: The program will be aborted." 
				echo
				exit 1 # Exit program with general error exit code.
			else # Delete $2 if contents match, redirect errors to /dev/null.
				echo "They are the same, $2 will be deleted."
				echo
				echo "$2 successfully deleted."
				echo
				exit 1
			fi
		elif [ $OUT -ne 0  -a $OUT -ne 1 ] # If cmp operation fails, exit program.
		then
			echo "${0}: ERROR 5: Unable to compare $1 to $2." 1>&2 # print to error channel.
			echo
			echo "${0}: The program will be aborted." 
			echo
			exit 1 # Exit program with general error exit code.	 	
		else 
			echo "They are differant, $2 will not be deleted."
			echo	# If file contents do not match, $2 will not be deleted.	 
		fi
	fi
fi

exit 0 # Exit program with successful program run exit code.
