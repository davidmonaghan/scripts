#!/usr/bin/python
import os, sys, getopt

# Cross platform method for clearing terminal screen.
os.system('cls' if os.name == 'nt' else 'clear')

print "\n _____________________________________________"
print "|                                             |"
print "|     Script that counts number of words,     |"
print "|    average word length, number of lines     |"
print "|   and number of charaters in a text file.   |"
print "|_____________________________________________|\n"

###############################
# o == option
# a == argument passed to the o
###############################

# Rather than printing error to screen if something unexpected is entered,
# instead try to parse command line arguments.
try:
	myopts, args = getopt.getopt(sys.argv[1:],"l:w:c:")
# If an error is thrown, save it to variable 'e'
except getopt.GetoptError as e:
	print (str(e)) # Print getopt error.
	print("Usage: %s -i Total Lines In File -w Total Words In File -c Total Characters In File" % sys.argv[0])
	sys.exit(2) # Exit program.

# For each option provided. o= option, a=File to check.
for o, a in myopts: 
	try: # Try open file given at command-line
		f = open(a, 'r')
	except IOError: # On error opening file, display message.
		print 'Cannot open', a
	else:
		numWords=0 # Variables for output based on option provided.
		numLines=0
		numChars=0
		
		# For the file currently open.
		with open(a,'r') as f:
			for line in f: # Read each line.
				# Split text ending with white-psace into seperate item
				words=line.split() 
				
				numWords+=len(words) # The number of words for each line.
				numChars+=len(line) # The number of non-whitepsace characters per line.
				numLines+=1 # Increment numLines by 1.
		
		# Depending on value given by user, output relvant information.
		if o == '-l':
			print "Number of line in",a,"is:",numLines
		elif o == '-w':
			print "Number of words in",a,"is:",numWords
			print "Average word-length in",a,"is:",numChars/numWords
		elif o == '-c':
			print "Number of characters in",a,"is: ",numChars
print "\n"
