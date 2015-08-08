#!/usr/bin/python

import sys, getopt, datetime, time, os

# Cross platform code for clearing terminal screen
os.system('cls' if os.name == 'nt' else 'clear')

print "\n ___________________________________________________________"
print "|                                                          |"
print "|        Script that recursively checks the time           |"
print "|    last access/ modification in current directory        |"
print "|          and for all files/subdirectories.               |"
print "|                                                          |"
print "| The user will input the max number of minutes to search. |" 
print "|             Range is 1-120 minutes.                      |"
print "|   The user can enter multiple timeframes.                |"
print "|__________________________________________________________|\n"

x=0 # The user can enter multiple times, counter allows to keep access correct argument.
for arg in sys.argv:
	x+=1 # Increment counter.
	try: # Try to save argument as an integer.
		accessTime = int(sys.argv[x])
	except ValueError: # If not integer, display error.
		print "\n[Error 1]",x,"argument",sys.argv[x],"is not an integer."
		print "Usage:",sys.argv[0],"PositiveIntegerLessThan120."
		print "Note: You can enter multiple values.\n"
	except IndexError: # If sys.argv[x] does not exist
		if len(sys.argv) < 2: # If user has not presented at least 1 argument, exit.
			print "[Error 2] You need to include at least one argument."
			print "Usage:",sys.argv[0],"PositiveIntegerLessThan120."
			print "Note: You can enter multiple values.\n"
			sys.exit(2) # Exit program.
		else: # If user has given at least 1 argument then there are no more arguments, break loop.
			break
	else: # If user argument is an integer.
		if accessTime > 120 or accessTime < 1: # Confirm interger is in valid range, print error otherwise.
			print "\n[Error 3]",x,"argument",sys.argv[x],"is out of range."
			print "Please enter a positive integer from 1 - 120."
			print "Usage: %s PositiveIntegerLessThan120\n" % sys.argv[0]
		else:
			print '\nIn the last %i minutes these files have been accessed:' % accessTime
			# Recursively check all files in current directory plus all files in sub-directories.
			for root, suddirs, files in os.walk("."):
				for name in files: # For each file name.
					fileName = os.path.join(root, name) # Create OS readable file path name.
										
					try: # Try to get the last time the current file was accessed.
						lastFileAccess = datetime.datetime.fromtimestamp(os.stat(fileName).st_atime)
					except OSError: # If OS throws error, exit loop.
						print "[Error 4] Unable to access %s.\n" % fileName
						break
					# Convert last access time to minutes.
					lastAccess = (datetime.datetime.now() - lastFileAccess).total_seconds()/60
					# If lastAccess is within users time-frame.
					if lastAccess <= accessTime:
						print "\n" # Display Date/ Time of last access and last modificiation in format MMM DD YYYY HH:MM
						print fileName,'last modified', datetime.datetime.fromtimestamp(os.stat(fileName).st_mtime).strftime('%b %d %Y at %H:%M')
						print fileName,'last accessed', datetime.datetime.fromtimestamp(os.stat(fileName).st_atime).strftime('%b %d %Y at %H:%M')	
		 
