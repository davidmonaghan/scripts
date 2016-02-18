#!/usr/bin/perl;
#
# David Monaghan - ITM 2 - R00103763
#
# Perl CGI script that will check user name and password against details on file.
# Once login credentials have been verified, 
# the user can input their date of birth and find how long they have been alive,
# in days, hours, minutes or seconds 
# and they can leave a comments and see comments left by previous users.
# Once they are finished they can log out.
#
# UserIDs & Passwords are stored in a file called 'password.txt'.
# Comments are stored in a file called 'comments.txt'.
# 
# Program is structured in the following way:
# Main Method -> Controller-> Process user input -> Generate next page.
                                                 
use strict;
use warnings; 
use CGI::Pretty ':standard'; # Use CGI module for generating HTML.
use CGI::Carp qw(fatalsToBrowser); # Send error messages to the browser.
use POSIX qw(strftime); # Used to manipulate integers into date/ time functions, 
				    # Used in this program to get the current day/Month/Year expressed as integers.

# Global variables used to allow for quick adjustment of the program.
my $contact="david.monaghan\@mycit.ie"; # Global variable used for printing to footer.
my $site='Days Alive'; # Global variable, used for printing to footer.
my $passwordFile = 'password.txt'; # Global variable name for file with userID & passwords.
my $commentsFile = 'comments.txt'; # Global variable name for file with user comments.
	
my $nowYear = strftime"%Y",localtime;  # Get the current date in Days/ Month/ Year using POSIX module, 
my $nowMonth = strftime"%m",localtime; # values saved to Global variables.
my $nowDay = strftime"%d",localtime;
my $currentYear = strftime"%d/%m/%Y",localtime;
open(DEBUG,">>","debug.txt");
print header(); # Tell browser HTML is on the way.

my $buttonPressed = param('next') ||'Start'; # Variable to store current page parameters i.e. user input from text boxes, drop down menus et..

&controller($buttonPressed); 
close DEBUG;

sub controller # Sub routine decides what to do with user input.
{
	# Integer variable being passed to subroutines below represent,
	# 1 = login page, 2 = calculator page, 3 = Enter a comment page, 4 = comment submitted successfully.
	
	my $previousButton = shift; # Get page buttons current label.
	my @errorMessage; 
	# Array will be loaded with program feedback, errors et
	# Position 0 = login credentials wrong, 
	# 1 = total days alive, 2 = total hours alive, 3 = total minutes alive, 4 = total seconds alive,
	# 5 = "Invalid date.", 6 = Error Details, 7 = "Please choose:" date option,
	# 8 = No day chosen, 9 = No month chosen, 10 = No year chosen,
	# 11 = No Comments User ID, 12 = No Comment Left,
	# 13 = Could Not Open File, 14 = Comment User ID, 15 = Comment Text.
	
	if($previousButton =~ /^Start$/ || $previousButton =~ /^Log Out$/) # If button has the default label, 
	{
		&buildPage(1,@errorMessage); # generate initial login page.
	}
	elsif($previousButton =~ /^Login$/ || $previousButton =~ /^Go To Calculate$/) # If the button has the login label,
	{
		if(&userNameCheck() || $previousButton =~ /^Go To Calculate$/) # check if user name/ password match a set in the 'password.txt' file
		{  				 # If it does match, generate the 'Days Alive' calculator page.
			&buildPage(2,@errorMessage);
		}
		else
		{    # If it doesn't, generate the login page and display the error message.
			$errorMessage[0] = '<font color="red">The user name or password is incorrect.</font>'; 
			&buildPage(1,@errorMessage);
		}
	}	
	elsif($previousButton =~ /^Calculate$/) # If button has the Calculate label
	{
		@errorMessage = &checkDateOfBirth(@errorMessage); #Check date of birth provided by the user
		
		if($errorMessage[5] eq "" && $errorMessage[6] eq "") # If $errorMessage has no text, no errors with user input
		{ 
			my @errorMessage = &totalDaysAlive(@errorMessage); # Calculate days since DOB until today,
			&buildPage(2,@errorMessage);     # generate Days Alive' calculator page with result.
		}
		else # If an error message has been returned from DOB error checking sub routines and
		{    # then display Days Alive' calculator page with relevant error massages.
			&buildPage(2,@errorMessage);
		}	
	}
	elsif($previousButton =~ /^Comments$/ || $previousButton =~ /^Enter A New Comment$/) # If the button has either 'Comments' or 'Enter A New Comment' label.
	{
		&buildPage(3,@errorMessage); # Generate the comment entry form.
	}
	elsif($previousButton =~ /^Submit Comment$/) # If the button has the 'Submit Comments' label.
	{
		@errorMessage = &commentsErrorCheck(@errorMessage); # Check that user has provided provided a 'Name' and a 'Comment'.
		
		if($errorMessage[11] eq "" && $errorMessage[12] eq "") # If no errors with user input.
		{
			&buildPage(4,@errorMessage); # Generate 'comment submitted successfully' page.
		}
		else
		{
			&buildPage(3,@errorMessage); # Generate comment entry form with error messages.
		}
	}
	else
	{
		&buildPage(0,@errorMessage); # Generate unspecific error page. 
	}
}

sub loadComments # Print all comments from the comments file to the screen.
{
	open(OUTFILE,"<","$commentsFile") or warn "Cannot open $commentsFile:$!\n";
	#Open comments file or send warning to browser.
	while(<OUTFILE>) # Continue loop while file has new input.
	{
		chomp (my $fileInput = $_); # Get Username.
		print ("Name: $fileInput<br>"); # Print to browser.
		chomp ($fileInput = <OUTFILE>); # Get comment.
		print ("coment: $fileInput<br><br>"); # Print to browser.
	}
	
	close INFILE; #Close comments file.
}

sub commentsErrorCheck # Check user name and password.
{
	my @message = @_; 
	# Array will be loaded with program feedback, errors et
	# Position 0 = login credentials wrong, 
	# 1 = total days alive, 2 = total hours alive, 3 = total minutes alive, 4 = total seconds alive,
	# 5 = "Invalid date.", 6 = Error Details, 7 = "Please choose:" date option,
	# 8 = No day chosen, 9 = No month chosen, 10 = No year chosen,
	# 11 = No Comments User ID, 12 = No Comment Left,
	# 13 = Could Not Open File, 14 = Comment User ID, 15 = Comment Text.
	my $alltext=param('commentsText'); # Save contents of 'commentsText' textarea.
	my @comments = $alltext =~ /(.+)(?:\n|$)/g; # Strip off any new line characters and save to array.
	my $commentsUserID = param('commentsUsername'); # Get contents of 'commentsUsername' textfield.
		              
	if(!param('commentsUsername') && !param('commentsText')) # If no text in both textfield & textarea.
	{
		$message[11] = '<font color="red">You have not given a name.</font>'; # Save error messages to error message array.
		$message[12] = '<font color="red">You have not entered any comments.</font>'; # Will be printed to browser later.
		return @message;
	}
	else
	{
		if(!param('commentsUsername')) # If no text in both textfield.
		{    # Save error messages to error message array.
			$message[11] = '<font color="red">You have not given a name.</font>';
		}
		elsif(!param('commentsText')) # If no text in both textarea.
		{    # Save error messages to error message array.
			$message[12] = '<font color="red">You have not entered any comments.</font>';
		}
		else
		{    # If all input provided.
			open(OUTFILE,">>","$commentsFile") or warn "Cannot open $commentsFile:$!\n"; 
			# Open comments file, send error message to browser.
			print OUTFILE "$commentsUserID\n"; # Print userName to comments file. 
						
			foreach my $comment(@comments) # Print user Comments to file.
			{
				print OUTFILE "$comment";
				$message[15] = $message[15].$comment; # Save a copy of comments to array for printing on next page.
			}
			
			print OUTFILE "\n"; # Print new line.
			close OUTFILE; # Close comments file.
			
			$message[14] = $commentsUserID; # Save user name and comment for printing on next page.
			
		}
		return @message; # Return error message array.
	}
}

sub buildPage # Builds the individual web page as determined by the variables passed from the controller page
{             # i.e. login page, calculator page or comments page with any relevant feedback.
	my $pageType = shift; 
	my @Message = @_;
	
	&buildHeader($pageType); # Build header
	&buildForm($pageType, @Message); # Build the page body
	&buildFooter; # Build footer
}

sub buildHeader 
{
	# 1 = login page, 2 = calculator page, 3 = Enter a comment page, 4 = comment submitted successfully.
	
	my $pageType = shift; # Which page header will we use, login or calculator.
	
	if($pageType==1) # If it's login page,
	{
		print start_html("$site - Login");
	}
	elsif($pageType==2) # else if it's the calculator page,
	{
		print start_html("$site - Calculator");
	}
	elsif($pageType==3 || $pageType==4) # else if it's a comment page
	{
		print start_html("$site - Comments");
	}
	else # and if it's none of those, print error message to browser.
	{
		print start_html("$site - ***");
	}
}

sub buildFooter # Printed at bottom of each page
{
	print hr, p, "Direct your queries to the \"$site\"  ", 
	a({href=>"mailto:$contact?subject=$site"},"Web-master");
	print end_html; # HTML code ends here
}

sub buildSubmitButton # Changes the label on the text button, 
{		     	  # determined by which form in next sub routine called it.	
	my $buttonName = shift; 
	
	return submit(-name=>'next', -value=>$buttonName);
}

sub buildForm # Builds either login form or calculator form
{
	my $form = shift;
	my @Message = @_;
	# Array will be loaded with program feedback, errors et
	# Position 0 = login credentials wrong, 
	# 1 = total days alive, 2 = total hours alive, 3 = total minutes alive, 4 = total seconds alive,
	# 5 = "Invalid date.", 6 = Error Details, 7 = "Please choose:" date option,
	# 8 = No day chosen, 9 = No month chosen, 10 = No year chosen,
	# 11 = No Comments User ID, 12 = No Comment Left,
	# 13 = Could Not Open File, 14 = Comment User ID, 15 = Comment Text.
	
	if($form == 1) # Login form
	{    # Array position represent 0 = login credentials wrong.
		# Prints following to the browser.
		print h1('Days Alive: Login'), p, start_form("post"), 
	
		table({-cellpadding=>'5',-cellspacing=>'5'}, # Displays text boxes for password, user ID & displays any error messages.

			Tr({-align=>'center',-valign=>'middle'},

				[td(["User Name: ",textfield(-name=>'username'),$Message[0],]), # Displays text boxes for user ID & displays any error messages.
					
				td(["Password: ",password_field(-name=>'password')]), # Displays text boxes for password.
					
				td({-colspan=>2},[&buildSubmitButton('Login'),]),	# Login Button.
				]
			)
		),
	}
	elsif($form == 2) # Displays Days Alive calculator form.
	{    # Array position represent
	     # 1 = total days alive, 2 = total hours alive, 3 = total minutes alive, 4 = total seconds alive,
	     # 5 = "Invalid date.", 6 = Error Details, 7 = "Please choose:" date option,
		# 8 = No day chosen, 9 = No month chosen, 10 = No year chosen.
		my @days=('Day'); # Used to store individual date values for use in drop down menus.
		my @months=('Month');
		my @years=('Year');
		
		for(my $i=1; $i<13; $i++) # Push values 1-12 into month and day.
		{
			push (@days,$i);
			push (@months,$i);
		}
		
		for(my $i=13; $i<32; $i++) # Push values 13 - 31 into month.
		{
			push (@days,$i);
		}
		
		for(my $i=$nowYear; $i>0; $i--) # Push values from current back to 1,
		{			                 #  displays current year first in drop down menu.
			push (@years, $i)
		}
		
		# Prints following to the browser
		print h1('Days Alive: Calculate Days'), p, start_form("get"), 
		
		table({-cellpadding=>'5',-cellspacing=>'5'}, # Displays any error massage and the day/month/year drop down menus for DOB.
		
			Tr({-align=>'left',-valign=>'middle'},
			
				[td(["Birth Date: ",popup_menu(-name=>'daybirth', -values=> \@days), # Displays day drop down menus for DOB.
						popup_menu(-name=>'monthbirth', -values=> \@months), 	    # Displays month drop down menus for DOB.
							popup_menu(-name=>'yearbirth', -values=> \@years),$Message[5]]), # Displays year drop down menus for DOB and any error message.
							
				td([$Message[7],$Message[8],$Message[9],$Message[10],$Message[6]]), # Displays error messages based on user input or lack thereof.	
				]													   # "Please input:" "Day" "Month" "Year"
			)	
		),
		
		table({-cellpadding=>'5',-cellspacing=>'5'}, # Displays any error massage and the day/month/year drop down menus for DOB.
		
			Tr({-align=>'left',-valign=>'middle'},
			
				[td(["Include: ",checkbox(-name=>'Today', -values=>['Today']),checkbox(-name=>'Total Hours Alive', -values=>['Total Hours Alive']), 
					checkbox(-name=>'Total Minutes Alive', -values=>['Minutes']), checkbox(-name=>'Total Seconds Alive', -values=>['Seconds'])]) 
				]													
			)	
		),
		
		table({-cellpadding=>'5',-cellspacing=>'5'}, # Displays the current date & total days alive once it's calculates.

			Tr({-align=>'left',-valign=>'middle'},

				[td(["Todays date is: ", $currentYear]), # Displays the current date.
				
				td(["Total time alive: ", $Message[1],$Message[2],$Message[3],$Message[4]]), # Displays total time alive once it's calculated.
				]                         # 1 = total days alive, 2 = total hours alive, 3 = total minutes alive, 4 = total seconds alive,
			)
		),
		
		table({-cellpadding=>'5',-cellspacing=>'5'}, # Displays the current date & total days alive once it's calculates.

			Tr({-align=>'left',-valign=>'middle'},

				[td({-align=>'center'},[&buildSubmitButton('Calculate'),&buildSubmitButton('Comments'),&buildSubmitButton('Log Out')]),
				]
			)
		),
	
		end_form();
	}
	elsif($form == 3) # Displays Days Alive enter a comment form.
	{
	     # Array position represent 11 = No Comments User ID, 12 = No Comment Left,
	     
		print h1('Days Alive: Comments'), p, start_form("get"),
		
		table({-cellpadding=>'5',-cellspacing=>'5'}, # Displays any error massage and the day/month/year drop down menus for DOB.
		
			Tr({-align=>'left',-valign=>'middle'},
			
				[td(["User Name: ",textfield(-name=>'commentsUsername'),$Message[11]]),
				]													
			)	
		),
			
		table({-cellpadding=>'5',-cellspacing=>'5'}, # Displays any error massage and the day/month/year drop down menus for DOB.
		
			Tr({-align=>'Center',-valign=>'middle'},
			
				[td(["Enter Your Comments Below",$Message[12]]),
				
				 td([textarea(-name=>'commentsText', -rows=>10, -columns=>50)]),
				]													
			)	
		),
		
		table({-cellpadding=>'5',-cellspacing=>'5'}, # Displays the current date & total days alive once it's calculates.

			Tr({-align=>'center',-valign=>'middle'},

				[td({-align=>'center'},[&buildSubmitButton('Submit Comment'),&buildSubmitButton('Go To Calculate'),&buildSubmitButton('Log Out')]),
				]
			)
		),
		
		end_form();
		
		print h2('Previous comments<br><br>');
		
		&loadComments;
	
	}
	elsif($form == 4)
	{
		# Array position represent, 14 = Comment User ID, 15 = Comment Text.
		print h1('Days Alive: Comment Submitted Successfully'), p, start_form("get"),
		# Display username and comment.
		('<strong>The comment reads</strong><br>'),("Name: $Message[14]<br>"),("Comment: $Message[15]"),
		
		table({-cellpadding=>'5',-cellspacing=>'5'}, # Displays any error massage and the day/month/year drop down menus for DOB.
		
			Tr({-align=>'Center',-valign=>'middle'},
			
				[td([h2("What Would You Like To Next?"),]),]													
			)	
		),
		
		table({-cellpadding=>'5',-cellspacing=>'5'}, # Displays the current date & total days alive once it's calculates.

			Tr({-align=>'center',-valign=>'middle'},

				[td({-align=>'center'},[&buildSubmitButton('Enter A New Comment'),&buildSubmitButton('Go To Calculate'),&buildSubmitButton('Log Out')]),
				]
			)
		),
	
		end_form();
	}
	else{ # If for some reason no form generation value is given, display error message on the web page.
		print h1('Days Alive: Form print error.');
	}
}
	
sub userNameCheck # Check user name and password.
{
	my $inputUserID = param('username'); # Get username from form.
	my $inputPassword = param('password'); # Get password from the form.
	my $fileUserID; # Saves username from password file.
	my $filePassword; #Saves password from password file.

	open(INFILE,"<","$passwordFile") or warn "Cannot open $passwordFile:$!\n"; 
	# Open password file, send error message to browser.

	while(<INFILE>) # Continue loop while file has new input.
	{
		chomp($fileUserID = $_); # Save first line of file as password and delete any trailing spaces.
		chomp($filePassword = <INFILE>); # Save next line of file as password and delete any trailing spaces.
		
		if($inputUserID ne "" && $inputUserID eq $fileUserID && $inputPassword eq $filePassword) 
		{# If form username is not blank & matches file username & password.
		 # The username not left blank condition is to prevent situations where the while loop 
		 # loads an empty string into $fileUserID and $filePassword and allows someone to login without credentials.
			return 1; # Username and password are good.
			
			close INFILE;
		}
	}
	
	close INFILE;
	
	return 0; # Username/password is either blank or does not exist on file or does not match password associated with username provided.
			# I removed code explaining which part of the login credentials where incorrect 
			# because most websites never tell you what the error is in that situation. 
}

sub checkDateOfBirth # Check DOB provided by the user.
{
	my @errorMessage = @_; # Import variable
	# Array will be loaded with program feedback, errors et
	# Position 0 = login credentials wrong, 
	#1 = total days alive, 2 = total hours alive, 3 = total minutes alive, 4 = total seconds alive,
	# 5 = "Invalid date.", 6 = Error Details, 7 = "Please choose:" date option,
	# 8 = No day chosen, 9 = No month chosen, 10 = No year chosen.
	
	@errorMessage = &checkYear(@errorMessage); # Check the Year provided by the user.
	
	if($errorMessage[6] ne "") # If future date error, return message array & end error checking.
	{
		return @errorMessage;
	}
	else # If no future date error, 
	{
		@errorMessage = &checkMonth(@errorMessage); # then check month provided by the user. 
		
		if($errorMessage[6] ne "")#  If future date or too many days in month error, return error message array & end error checking.
		{
			return @errorMessage;
		}
		else # If no future date or too many days in month error, 
		{
			@errorMessage = &checkDay(@errorMessage); # check day provided by the user, return error message array.
			
			return @errorMessage;
		}
	}
}

sub checkYear # Checks that a valid year has been provided by the user.
{
	my $yearBirth = param('yearbirth');
	my @errorMessage = @_;
	# Array will be loaded with program feedback, errors et
	# Position 0 = login credentials wrong, 
	# 1 = total days alive, 2 = total hours alive, 3 = total minutes alive, 4 = total seconds alive,
	# 5 = "Invalid date.", 6 = Error Details, 7 = "Please choose:" date option,
	# 8 = No day chosen, 9 = No month chosen, 10 = No year chosen,
	# 11 = No Comments User ID, 12 = No Comment Left,
	# 13 = Could Not Open File, 14 = Comment User ID, 15 = Comment Text.
	
	if(!&isNumeric($yearBirth)) # Confirms the user has chosen a year, default drop down option is "Year".
	{    # Return error messages array and exit sub routine.
		$errorMessage[5] = '<font color="red">Invalid date.</font>'; 
		$errorMessage[7] = '<font color="red">Please choose a: </font>';
		$errorMessage[10] = '<font color="red">Year</font>';
		return @errorMessage;
	}
	else
	{
		if($yearBirth>$nowYear) # check if it's a future year.
		{	# Return error messages array and exit sub routine.
			$errorMessage[5] = '<font color="red">Invalid date.</font>';
			$errorMessage[6] = "<font color=\"red\">The year of birth $yearBirth is after the current year of $nowYear.</font>"; # Return error message and exit sub routine.
			$errorMessage[7] = '<font color="red">Please choose a: </font>';
			$errorMessage[10] = '<font color="red">Year</font>';
			return @errorMessage;
		}
		else
		{	 # Return error messages and exit sub routine.
			$errorMessage[6] = ""; # Return error message and exit sub routine.
			return @errorMessage;
		}
	}	
}

sub checkMonth # Checks that a valid month has been provided by the user.
{
	my $yearBirth = param('yearbirth');
	my $monthBirth = param('monthbirth');
	my @errorMessage = @_;
	# Array will be loaded with program feedback, errors et
	# Position 0 = login credentials wrong, 
	# 1 = total days alive, 2 = total hours alive, 3 = total minutes alive, 4 = total seconds alive,
	# 5 = "Invalid date.", 6 = Error Details, 7 = "Please choose:" date option,
	# 8 = No day chosen, 9 = No month chosen, 10 = No year chosen.
	
	if(!&isNumeric($monthBirth)) # Confirms the user has chosen a month, default drop down option is "Month".
	{	# Return error messages array and exit sub routine.
		$errorMessage[5] = '<font color="red">Invalid date.</font>'; 
		$errorMessage[7] = '<font color="red">Please choose a: </font>';
		$errorMessage[7] = '<font color="red">Please choose a: </font>';
		$errorMessage[9] = '<font color="red">Month</font>';
		return @errorMessage;
	}
	else
	{	
		if($yearBirth==$nowYear && $nowMonth<$monthBirth) # Confirms it's not a future month.
		{	# Return error messages array and exit sub routine.
			$errorMessage[5] = '<font color="red">Invalid date.</font>';
			$errorMessage[6] = "<font color=\"red\">The date $monthBirth/$yearBirth is after the current date of $nowMonth/$nowYear.</font>"; # Return error message and exit sub routine.
			$errorMessage[7] = '<font color="red">Please choose a: </font>';
			$errorMessage[9] = '<font color="red">Month</font>';
			$errorMessage[10] = '<font color="red">Year</font>';
			return @errorMessage;
		}
		else
		{	# Return error messages array and exit sub routine.
			$errorMessage[2] = ""; # Return error message and exit sub routine.
			return @errorMessage;
		}
	}
}

sub checkDay # Checks that a valid day has been provided by the user
{
	my $yearBirth = param('yearbirth');
	my $monthBirth = param('monthbirth');
	my $dayBirth = param('daybirth');
	my @errorMessage = @_;
	# Array will be loaded with program feedback, errors et
	# Position 0 = login credentials wrong, 
	# 1 = total days alive, 2 = total hours alive, 3 = total minutes alive, 4 = total seconds alive,
	# 5 = "Invalid date.", 6 = Error Details, 7 = "Please choose:" date option,
	# 8 = No day chosen, 9 = No month chosen, 10 = No year chosen.
	
	if(!&isNumeric($dayBirth)) # Confirms the user has chosen a day, default drop down option is "Day".
	{	# Return error messages array and exit sub routine.
		$errorMessage[5] = '<font color="red">Invalid date.</font>'; 
		$errorMessage[7] = '<font color="red">Please choose a: </font>';
		$errorMessage[8] = '<font color="red">Day</font>';
		return @errorMessage;
	}
	else 
	{
		my $daysInMonth=&daysInMonth($monthBirth, $yearBirth); # Get number of days for the users birth month  
			
		if($dayBirth>$daysInMonth) # If user a value greater than number of days for the month chosen
		{    # Return error messages array and exit sub routine.
			$errorMessage[5] = '<font color="red">Invalid date.</font>';
			$errorMessage[6] = "<font color=\"red\">There are only $daysInMonth days in the month chosen.</font>";
			$errorMessage[7] = '<font color="red">Please choose a: </font>';
			$errorMessage[8] = '<font color="red">Day</font>';
			$errorMessage[9] = '<font color="red">Month</font>';
			return @errorMessage;
		}
		else
		{	# If date is a future date.
			if($yearBirth==$nowYear && $nowMonth==$monthBirth && $nowDay<$dayBirth) 
			{ 	# Return error messages array and exit sub routine.
				$errorMessage[5] = '<font color="red">Invalid date.</font>';
				$errorMessage[6] = "<font color=\"red\">The date $nowDay/$monthBirth/$yearBirth is after the current date of $currentYear.</font>";
				$errorMessage[7] = '<font color="red">Please choose a: </font>';
				$errorMessage[8] = '<font color="red">Day</font>';
				$errorMessage[9] = '<font color="red">Month</font>';
				$errorMessage[10] = '<font color="red">Year</font>';
				return @errorMessage;
			}
			else
			{	# Return error messages array and exit sub routine.
				$errorMessage[6] = ""; 
				return @errorMessage;
			}
		}
	}
}

sub totalDaysAlive
{
	my @messages = @_;
	my $dayBirth = param('daybirth');
	my $monthBirth = param('monthbirth');
	my $yearBirth = param('yearbirth');
	my @values;
	my @checkBox =  param('extraDates');
	my $daysAlive = 0;
	my $hoursAlive;
	my $minutesAlive;
	my $secondsAlive; 
	
	#'Today', 'Total Seconds Alive', 'Total Minutes Alive', 'Total Seconds Alive'
	
		
	if($yearBirth == $nowYear && $monthBirth == $nowMonth) # Someone born this month and this year
	{
		$daysAlive = $nowDay - $dayBirth; # For someone born this month, including the day they where born.
	}
	else 
	{
		$daysAlive = $nowDay; # Adds number of days so far this month, default value excludes today in the calculation.
	
		for(my $i = 1;$i < $nowMonth; $i++) # Adds number of days this year excluding the current month.
		{
			my $daysInMonth = &daysInMonth($i,$nowYear);
			$daysAlive += $daysInMonth;
		}
	
		if($yearBirth != $nowYear) # Exclude people born this year.
		{
			my $daysInMonth = &daysInMonth($monthBirth,$yearBirth);
			
			$daysAlive += $daysInMonth-$dayBirth+1; # Adds the number of days from birth-date until end of birth month.
										     # Includes the day person was born in the calculation.
	
			for(my $i = 12;$i > $monthBirth; $i--) # Adds number of days after birth month until the end of the year.
			{
				my $daysInMonth = &daysInMonth($i,$yearBirth);
				$daysAlive = $daysAlive + $daysInMonth;	
			}
		}
	
		for(my $i = $yearBirth + 1; $i < $nowYear; $i++) # adds the number of days per year, 
		{						 # excluding the current year and year of birth.	
			if(&isLeapYear($i))
			{
				$daysAlive += 366; # Is a leap year.
			}
			else
			{
				$daysAlive += 365; # Not a leap year.
			}
		}	
	}
	
	if(!param('Today'))
	{
		$daysAlive -= 1;
	}
	if(param('Total Hours Alive'))
	{
		$hoursAlive = $daysAlive*24," hours alive.";
		$messages[2] = "<font color=\"green\"> $hoursAlive hour(s), </font>";
	}
	if(param('Total Minutes Alive'))
	{
		$minutesAlive = $daysAlive*24*60," minutes alive.";
		$messages[3] = "<font color=\"green\"> $minutesAlive minute(s), </font>";
	}
	if(param('Total Seconds Alive'))
	{
		$secondsAlive = $daysAlive*24*60*60," seconds alive.";
		$messages[4] = "<font color=\"green\"> $secondsAlive second(s), </font>";
	}
	
	
	# The array 'messages' will be loaded with program feedback, errors et
	# Position 0 = login credentials wrong, 
	# 1 = total days alive, 2 = total hours alive, 3 = total minutes alive, 4 = total seconds alive,
	# 5 = "Invalid date.", 6 = Error Details, 7 = "Please choose:" date option,
	# 8 = No day chosen, 9 = No month chosen, 10 = No year chosen. 
	
	$messages[1] = "<font color=\"green\"> $daysAlive day(s), </font>";
	
	return @messages;
}

sub daysInMonth # Calculates the days in any given month. 
{
	my $month = shift;
	my $year = shift;
	
	if($month == 4 || $month == 6 || $month ==9  || $month == 11) # If month is April, June, September or November 
	{										       # it will return 30.
	    	return 30;
	}
	elsif($month == 2) # If the month is February, it will check if the given year is a leap year.
	{
		my $isLeapYear = &isLeapYear($year);
			
		if(&isLeapYear($year))
		{
			return 29; # is a leap year.		
		}
		else
		{
			return 28; # is not a leap year.
		}
	}
	else # Returns 31 for all other months
	{
		return 31;
	}
}

sub isLeapYear # Calculates if any given year is a leap year or not.
{
	my $year = shift;
	
	if($year % 400 == 0)
	{
		return 1 # is a leap year.
	}
	elsif($year % 100 == 0)
	{
		return 0 # is not a leap year.
	}
	elsif($year % 4 == 0)
	{
		return 1 # is a leap year.
	}
	else
	{
		return 0; # is not a leap year.
	}
}

sub isNumeric # Confirms that the variable provided is an integer.
{ 	 
	my($n) = @_; #Get user input.

	if ($n =~ /^-?(?:\d+(?:\.\d*)?|\.\d+)$/ )
	{ #i.e. if $n matches a string as specified by this 'regular expression'
		return 1; #true
	}
	else
	{
		return 0; #false
	}
}

