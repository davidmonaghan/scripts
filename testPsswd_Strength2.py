#! /usr/bin/python

import re
import os

# Cross platform method for clearing terminal screen.
os.system('cls' if os.name == 'nt' else 'clear')

print "\n _____________________________________"
print "|                                     |"
print "|  Script to test password strength.  |"
print "|_____________________________________|"

usrPasswd = raw_input("\nEnter a password:  ")

if re.search(r'(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[\W]).{15,}', usrPasswd):
	# Password contains 1 uppercase letter, 1 lowercase letter, 1 number, 
	# 1 non-alpanumeric character and is minimum of 15 characters in length.
	print "A very strong password.\n"
	# Test password: pA$sword15digit
elif re.search(r'(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[\W]).{10,}', usrPasswd):
	# Password contains 1 uppercase letter, 1 lowercase letter, 1 number, 
	# 1 non-alpanumeric character and is minimum of 10 characters in length.
	print "A strong password.\n"
	# Test password: pA$sword10
elif re.search(r'(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{10,}', usrPasswd):
	# Password contains 1 uppercase letter, 1 lowercase letter, 1 number 
	# and is minimum of 10 characters in length.
	print "An average password.\n"
	# Test password: pAssword10
elif re.search(r'(?=.*[A-Z])(?=.*[a-z]).{10,}', usrPasswd):
	# Password contains 1 uppercase letter, 1 lowercase letter 
	# and is minimum of 10 characters in length.
	print "A weak password.\n"
	# Test password: pAsswordaa
else:
	# Anything else.
	print "A very weak password.\n"
	# Test password: password
	
# regex explanatory: re.search(r'(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[\W]).{15,}', usrPasswd)
#
# re: re is Pythons regex module and needs to be imported. 
# re.search: search string for matching pattern.
# r: Python notation donoting raw string, it avoids conflict with Pythons usage of \.
#
# (?=.*[A-Z]) Has at least 1 upper-case letter.
# ?=.* Has a least 1, or more accurately any number, of following pattern.
# (?=.*[a-z]) Has at least 1 lower-case letter.
# (?=.*[0-9]) Has at least 1 number.
# (?=.*[\W]) Has at least 1 non-alphanumeric character..
# Each requirement of the password strength meter is placed in brackets,
# so entire string is search for that pattern, if one is missing a False value is returned.
# .{15,} String has minumum 15 characters.
