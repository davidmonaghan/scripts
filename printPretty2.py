#! /usr/bin/python

import os
import random

# Cross platform method for clearing terminal screen.
os.system('cls' if os.name == 'nt' else 'clear')

print "\n _____________________________________________"
print "|                                             |"
print "|  Script to print N nested opening brackets  |"
print "|     and N closing brackets e.g. [[]]        |"
print "|_____________________________________________|\n"

# Generate a random value for variable randomVar
randomVar = random.randrange(3,20)
print "Randomly generated value for N: ",randomVar,"\n"

# In each of the following For loops the final value of x will be randomVar - 1
# With this in mind we need to ensure any even N numbers have the final bracket printed out
# which is done by the final if statement in each pattern.

# The following For will generate [ ] [ ] [ ] [ ] [ ] pattern where randomVar == 11.
for x in range(1, randomVar):
	# If x/2 has remainder of 1
	if x%2==1:
		print "[",
	# If x/2 has remainder of 0
	else:
		print "]",
	
	# If it's last iteration and x is an odd number.
	# Print an extra closing bracket.
	if x==randomVar-1 and x%2==1:
		print "]"
print "\n\n"

# The following For will generate [ [ [ [ [ ] ] ] ] ] pattern where randomVar == 11.
for x in range(1, randomVar):
	# If for loop is less than or halfway through it's iterations.
	if x<=randomVar/2:
		print "[",
	# If for loop is past or at halfway point.
	else:
		print "]",
	
	# If it's last iteration and x is an odd number.
	if x==randomVar-1 and x%2==1:
		print "]",
	
print "\n\n"

# The following For will generate [ [ ] [ ] [ ] [ ] ]  pattern where randomVar == 11.
for x in range(1, randomVar):
	# If it's the first loop iteration. 
	if x==1:
		print "[",
	# It's an even number and it's not the last iteration.
	elif x%2==0 and x!=randomVar-1:
		print "[",	
	else: 
		print "]",
	
	# If it's last iteration and x is an odd number.
	if x==randomVar-1 and x%2==1:
		print "]",

print "\n\n"
