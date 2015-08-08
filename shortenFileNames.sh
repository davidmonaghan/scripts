#! /bin/bash

# This program will create mp3 files with the filenames
# given in the assignment and place them into a directory.
# It will then extract the names of files from the directory,
# shorten those filenames and rename the files with the shortened filename.

echo "***************************************************************"
echo "***************************************************************"
echo "***                                                         ***"
echo "***       Take a list of file names and shorten them.       ***"
echo "***                                                         ***"
echo "***    This program will read filenames in a directory      ***"
echo "***       shorten those names and rename the files.         ***"
echo "***                                                         ***"
echo "***************************************************************"
echo "***************************************************************"
echo

if [[ ! -e oldMp3directory ]]  # if "coursesMp3directory" does not exist then create one.
then 
	if ! mkdir oldMp3directory # If unable to create "coursesMp3directory", display error and exit.
	then 
		echo
		echo "${0}: ERROR 1: Unable to create \"oldMp3directory\" directory." 1>&2
		echo
		echo "${0}: The program will be aborted." 
		echo
		exit 1 # Exit program with general error exit code.
	fi
fi

# If unable to create file "createCourseMp3.txt", display error and exit.
# "createCourseMp3.txt" saves the names of each of the files to be created.
if ! printf "Scripting_Course_1A_2013_ED.mp3 
Scripting_Course_1B_2013_ED.mp3
Scripting_Course_1C_2013_ED.mp3
Scripting_Course_1D_2013_ED.mp3
Scripting_Course_1E_2013_ED.mp3
Scripting_Course_1F_2013_ED.mp3
Scripting_Course_2A_2013_ED.mp3
Scripting_Course_2B_2013_ED.mp3
Scripting_Course_2C_2013_ED.mp3
Scripting_Course_2D_2013_ED.mp3
Scripting_Course_2E_2013_ED.mp3
Scripting_Course_2F_2013_ED.mp3
Scripting_Course_3A_2013_ED.mp3
Scripting_Course_3B_2013_ED.mp3
Scripting_Course_3C_2013_ED.mp3
Scripting_Course_3D_2013_ED.mp3
Scripting_Course_3E_2013_ED.mp3
Scripting_Course_3F_2013_ED.mp3
Scripting_Course_4A_2013_ED.mp3
Scripting_Course_4B_2013_ED.mp3
Scripting_Course_4C_2013_ED.mp3
Scripting_Course_4D_2013_ED.mp3
Scripting_Course_4E_2013_ED.mp3
Scripting_Course_4F_2013_ED.mp3
Scripting_Course_5A_2013_ED.mp3
Scripting_Course_5B_2013_ED.mp3
Scripting_Course_5C_2013_ED.mp3
Scripting_Course_5D_2013_ED.mp3
Scripting_Course_5E_2013_ED.mp3
Scripting_Course_5F_2013_ED.mp3
Scripting_Course_6A_2013_ED.mp3
Scripting_Course_6B_2013_ED.mp3
Scripting_Course_6C_2013_ED.mp3
Scripting_Course_6D_2013_ED.mp3
Scripting_Course_6E_2013_ED.mp3
Scripting_Course_6F_2013_ED.mp3" >createCourseMp3.txt # Close createCourseMp3.txt
then
	echo
	echo "${0}: ERROR 2: Unable to create file \"createCourseMp3.txt\"." 1>&2
	echo
	echo "${0}: The program will be aborted." 1>&2
	echo
	exit 1 # Exit program with general error exit code.
fi

mv createCourseMp3.txt oldMp3directory/createCourseMp3.txt 
# Move createCourseMp3.txt to oldMp3directory
cd oldMp3directory 2>/dev/null # change directory to oldMp3directory

cat createCourseMp3.txt | while read LINE # Open and read each line of "createCourseMp3.txt"
do	
	if ! >$LINE 2>/dev/null # If unable to create mp3, dump errors to /dev/null. 
	then
		# Print error to error channel.
		echo "${0}: ERROR 3: Unable to create file $LINE" 1>&2
		echo
	fi
done <createCourseMp3.txt # Close "createCourseMp3.txt"

rm createCourseMp3.txt 2>/dev/null  # Delete createCourseMp3.txt
cd .. # Move up one directory

if [[ ! -e newMp3directory ]]  # if "coursesMp3directory" does not exist then create one.
then 
	if ! mkdir newMp3directory # If unable to create "coursesMp3directory", display error and exit.
	then 
		# Print error to error channel.
		echo "${0}: ERROR 4: Unable to create \"newMp3directory\" directory." 1>&2
		echo
		echo "${0}: The program will be aborted." 
		echo
		exit 1 # Exit program with general error exit code.
	fi
fi

for oldCourseName in oldMp3directory/* # Read each file in current directory "coursesMp3directory"
do 
	newCourseName=$( echo "$oldCourseName" | grep -Eo '[0-9]{1}[A-Z]{1}' | awk '{ print $0".mp3" }' )
	# Save the shortened mp3 filename to variable "newCourseName".
	
	cd newMp3directory # Change directory to newMp3directory
		
	if ! >$newCourseName 2>/dev/null # If unable to create mp3, dump errors into /dev/null. 
	then # Print error to error channel.
		echo "${0}: ERROR 5: Unable to create file $newCourseName" 1>&2
	else # Print successful mp3 creation.
		echo "Successfully created file $newCourseName"
	fi
	
	cd .. # Move up one directory
done	

echo # Display contents of oldMp3directory
echo "Contents of \"oldMp3directory\""
ls oldMp3directory
echo

# Display contents of newMp3directory
echo "Contents of \"newMp3directory\""
ls newMp3directory
echo

exit 0 # Exit program with successful program run exit code.
