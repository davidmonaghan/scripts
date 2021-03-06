#!/usr/bin/python
# Generate all prime numbers < 1000

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
	#print number, "is",
	
	# Call prime number check function.
	if isPrime(number):
		print number," is prime."
	
	#if not isPrime(number):
	#	print number," is not prime."

threads = []
for x in range(2, 1000):
	a = threading.Thread(target=checkThread(x))
	threads.append(a)
	a.start
