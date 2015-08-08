#! /usr/bin/python
# Test Password Strength

import re
import os

# Cross platform method for clearing terminal screen.
#os.system('cls' if os.name == 'nt' else 'clear')

print "\n _____________________________________"
print "|                                     |"
print "|  Script to test password strength.  |"
print "|_____________________________________|"

usrPasswd = raw_input("\nEnter a password:  ")

if (len(usrPasswd) >= 15 and any(x.isupper()for x in usrPasswd) and any(x.islower()for x in usrPasswd) and any(x.isdigit()for x in usrPasswd) and re.search(r'(?=.*[\W])', usrPasswd)):
	# Password contains 1 uppercase letter, 1 lowercase letter, 1 number, 
	# 1 non-alpanumeric character and is minimum of 15 characters in length.
	print "A very strong password.\n"
	# Test password: pA$sword15digit
elif (len(usrPasswd) >= 10 and any(x.isupper()for x in usrPasswd) and any(x.islower()for x in usrPasswd) and any(x.isdigit()for x in usrPasswd) and re.search(r'(?=.*[\W])', usrPasswd)):
	# Password contains 1 uppercase letter, 1 lowercase letter, 1 number, 
	# 1 non-alpanumeric character and is minimum of 10 characters in length.
	print "A strong password.\n"
	# Test password: pA$sword10
elif (len(usrPasswd) >= 10 and any(x.isupper()for x in usrPasswd) and any(x.islower()for x in usrPasswd) and any(x.isdigit()for x in usrPasswd)):
	# Password contains 1 uppercase letter, 1 lowercase letter, 1 number 
	# and is minimum of 10 characters in length.
	print "An average password.\n"
	# Test password: pAssword10
elif (len(usrPasswd) >= 10 and any(x.isupper()for x in usrPasswd) and any(x.islower()for x in usrPasswd)):
	# Password contains 1 uppercase letter, 1 lowercase letter 
	# and is minimum of 10 characters in length.
	print "A weak password.\n"
	# Test password: pAsswordaa
else:
	# Anything else.
	print "A very weak password.\n"
	# Test password: password
	
# If statement explanatory: if (len(usrPasswd) >= 15 and any(x.isupper()for x in usrPasswd) 
# and any(x.islower()for x in usrPasswd) and any(x.isdigit()for x in usrPasswd) 
# and re.search(r'(?=.*[\W])', usrPasswd)):

# len(usrPasswd) >= 15 Return true if string length is at least 15

# any(x.isupper()for x in usrPasswd) return true if any character is uppercase.
# Placed into for loop so each character is tested, 
# without for loop false would be returned if ther was a single non uppercase letter.

# any(x.islower()for x in usrPasswd) return true if any character is lowercase.

# any(x.isdigit()for x in usrPasswd) return true if any character is a digit.

# re.search(r'(?=.*[\W])', usrPasswd)): return true if any character is a non-alphanumeric character.
# re: re is Pythons regex module and needs to be imported. 
# re.search: search string for matching pattern.
# r: Python notation donoting raw string, it avoids conflict with Pythons usage of \.
# # ?=.* Has a least 1, or more accurately any number, of following pattern.
# [\w] non-alphanumeric character
