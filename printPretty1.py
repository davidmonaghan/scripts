#! /usr/bin/python

import os
import random

# Cross platform method for clearing terminal screen.
os.system('cls' if os.name == 'nt' else 'clear')

# Generate a random value for variable randomVar
openBracket = random.randrange(1,20) # Generate random value for number opening 
closeBracket = random.randrange(1,20) # and closing brackets.

print "\n _____________________________________________"
print "|                                             |"
print "|  Script to print N nested opening brackets  |"
print "|     and N closing brackets e.g. [[]]        |"
print "|_____________________________________________|\n"

# In each of the following loops the only way the patterns can be balanced
# is if the values of openBracket and closeBracket are equal.
def printResult():
	print "\n"
	
	if openBracket == closeBracket:
		print "Pattern:   OK\n"
	else:
		print "Pattern:   NOT OK\n"
	
	print "\n"

print "Randomly generated value for N open brackets: %i" % openBracket
print "Randomly generated value for N close brackets: %i\n\n" % closeBracket

print "Pattern 1 = [ ] [ ] [ ] [ ] [ ]"
print "e.g. Where N Open brackets and Close Brackets = 5.\n"
x = 0
while True:
	# While x less than equal to openBracket.
	if x<=openBracket:
		print "[",
	# While x less than equal to openBracket.
	if x<=closeBracket:
		print "]",
	# Once x is equal to whichever value is highest, break while loop.
	if x>=openBracket and x>=closeBracket:
		break
	x+=1

# Call printResult function.
printResult()

print "Pattern 2 = [ [ [ [ [ ] ] ] ] ]"
print "e.g. Where N Open brackets and Close Brackets = 5.\n"
x=0
while True:
	# Print all open brackets.
	for y in range(0,openBracket):
		print "[",
	# Print all closed brackets.
	for z in range(0,closeBracket):
		print "]",
	
	break # Ecit while loop.

# Call printResult function.
printResult()

print "Pattern 3 = [ [ ] [ ] [ ] [ ] ]"
print ".eg. Where N Open brackets and Close Brackets = 5.\n"

# Print outside opening bracket.
# If openBracket==1, only this will be printed.
print "[",

x=1		
while True:
	# Print open brackets, stop at openBrackets -1.
	# If openBracket == 1 then nothing will be printed.
	if x<=openBracket-1:
		print "[",
	# Print close brackets, stop at openBrackets -1.
	# If closeBracket == 1 then nothing will be printed.
	if x<=closeBracket-1:
		print "]",
	# Exit loop when highest value - 1 isreached.
	if x>=openBracket-1 and x>=closeBracket-1:
		break
	x+=1

# Print outside closing bracket.
# If closeBracket==1, only this will be printed.	
print "]",

# Call printResult function.	
printResult()
