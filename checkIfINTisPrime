#!/usr/bin/python

import threading, math, os, sys

# Function determines if number is a prime number or not
def isPrime(number):
	if number % 2 == 0 and number != 2:
		return False # Not Prime
		
	for z in range(3, int(math.sqrt(number)) + 1,2):
		if number % z == 0: # Not prime.
			return False
			
	return True # Prime.

# Function prints out result of prime number check.
def checkThread(number): 
	print number, "is",
	
	# Call prime number check function.
	if isPrime(number):
		print "prime."
	else:
		print "not prime."

threads = []

#Error check user input.
for x in range(1,6):
	try: # Try to save current argument as integer.
		userInput = int(sys.argv[x])
	except ValueError: # If not integer
		print "[Error 1]",x,"argument",sys.argv[x],"is not an integer."
	except IndexError:
		print "[Error 2] You need to include 5 arguments."
		print "Usage: %s Int Int Int Int Int" % sys.argv[0]
		print "Note: You can enter multiple values.\n"
		sys.exit(2) # Exit program.
	else:
		if len(sys.argv) != 6:
			print "[Error 3] You need to include 5 arguments."
			print "Usage: %s Int Int Int Int Int." % sys.argv[0]
			print "Note: You can enter multiple values.\n"
			sys.exit(2) # Exit program.
		elif userInput < 0:
			print "[Error 4]",x,"argument",sys.argv[x],"is a negative integer."
		else:
			userInput = int(sys.argv[x])
			a = threading.Thread(target=checkThread(userInput))
			a.start

