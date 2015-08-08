#!/usr/bin/python
import os, random

# Cross platform code for clearing terminal screen
os.system('cls' if os.name == 'nt' else 'clear')

print "\n            _____________________________________"
print "           |                                     |"
print "           |           A Game Of Lingo           |"
print "           |_____________________________________|"

print "\n####################################################################"
print "#                   Rules of the game                              #"
print "#                                                                  #"
print "#  1: A 5 letter word is chosen at random                          #"
print "#  2: You have a maximum of 5 guesses at the chosen word.          #"
print "#  3: Where a letter in your guess matches both character          #" 
print "#     and position it will be marked by [] parenthesis.            #"
print "#  4: Where a letter in your guess matches a letter in chosen word #"         
print "#     but not it's position it will be marked by () parenthesis.   #"
print "#                                                                  #"
print "####################################################################"

# Function that compares users guess with hidden word and formats users guess.
def compareString(userString, lingoString):
	for w in range(len(userString)): # Read each letter in users guess.
		# If letter is the same at postion 'w', print letter in [] brackets.
		if userString[w] == lingoString[w]: 
			print '[',userString[w],']',
		# If letter in position 'w' matches a letter in any position of hidden word,
		# print letter in () brackets.
		elif userString[w] in lingoString:
			print '(',userString[w],')',
		# Else if no match print letter without any parentheses.
		else:
			print userString[w],
			
# Try to open file containing list of lingo words, throw error and exit if file unable to be opened.
try:
	a = open('lingo.txt',"r") # Save file location to a
except IOError:
	print "\n[Error 1] Could not open lingo.txt"
	print "The script will terminate.\n"
else:
	lingoWords = [] # Store all 50 possible hidden words in list.
	
	for line in a: # Open file and read each line.
		line = line.rstrip() # Remove trailing spaces.
		lingoWords.append(line) # Add line to hidden words list.
	
	randomLingo = random.choice(lingoWords) # Randomly select a word from hidden words list.
	print ("\nThe hidden word (shown for testing only): %s\n" % randomLingo) 

	guessNumber = 1 # Counts the number of user guesses.

	# Loop will continue until either user guesses hidden word or incorrect guesses number 5 in total.
	while True:
		# Get users first guess
		usrGuess = raw_input ("\nPlease enter guess %i:" % guessNumber)
	
		# Loop will check that users input is 5 characters long and will loop again if not.
		while True: 
			if len(usrGuess) != 5: # If input not 5 characters long, print error and get user input again
				print ("[Error] %s is not 5 chracters long." % usrGuess)
				usrGuess = raw_input ("Please re-enter guess %i:" % guessNumber)
			else: # If input is 5 characters, exit loop
				break
	
		# Call compareString function, prints formatted string after usrGuess is compared to randomLingo
		compareString(usrGuess,randomLingo)
	
		# If current users guess matches hidden word, exit loop.
		if usrGuess == randomLingo:
			print "\n\nYou won.\n"
			break
		# If limit of guess reached, exit loop.	
		if guessNumber == 5:
			print ("\n\nYou lost: The correct word is %s.\n" % randomLingo)
			break
	
		guessNumber+=1

