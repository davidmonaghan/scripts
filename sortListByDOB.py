#! /usr/bin/python

import datetime, operator # datetime is used for working with dates and times.
					 # operator is used for sorting dictionaries into ordered tuples.

# Cross platform method for clearing terminal screen.
os.system('cls' if os.name == 'nt' else 'clear')

print "\n ______________________________________________________"
print "|                                                      |"
print "|            Script that takes a list of names         |"
print "|         and their dates of briths from a file.       |"
print "|   It will output the unordered list DOB, age, name   |"
print "|     and then ouput the ordered by youngest first.    |"
print "|______________________________________________________|\n"

format = '%d/%m/%Y' # Sets date format at dd/mm/yyyy e.g. 08/04/1956
now =datetime.datetime.now() # Gets the current date.
peopleDict = {} # Dictionary that saves values read in from 'people.txt' file

def getAge(DOB): # Function gets DOB, will take into count leap years.
	age = now.year - DOB.year - ((now.month, now.day) < (DOB.month, DOB.day))
	return age # returns persons age.

try: # Try open people.txt file or print error.
	a = open('people.txt',"r") # Save file location to a
except IOError:
	print "\n[Error 1] Could not open lingo.txt"
	print "The script will terminate.\n"
else:
	for line in a: # Read each line in people.txt
		line = line.rstrip() # string any leading or trailing spaces.
		name, date = line.split(",") # split line into 2 variables.
		DOB = datetime.datetime.strptime(date.strip(), format) # Convert Date string to datetime object.
		peopleDict[name]=DOB # Save name as key and DOB as value

	a.close() # Close people.txt

	print "\nPrinting unsorted list of people with DOB, age, name.\n"

	for name, DOB in peopleDict.items(): # Read each key in peopleDict dictionary.
		age = getAge(DOB) # Call getAge function of persons DOB.
		print DOB.strftime('%d/%m/%y'),age, name # Print out values. Use dd/mm/YYYY format for DOB.
	
	print "\nPrinting sorted list of people with DOB, age, name.\n"

	# Sort value DOB in descending order into tuple sortedDOB
	sortedDOB = sorted(peopleDict.items(),key=operator.itemgetter(1), reverse=True)

	for (name, DOB) in sortedDOB: # For each key/value in sortedDOB tuple
		age = getAge(DOB) # Call getAge function of persons DOB.
		print DOB.strftime('%d/%m/%y'),age, name # Print out values. Use dd/mm/YYYY format for DOB.
	
	print "\n"
