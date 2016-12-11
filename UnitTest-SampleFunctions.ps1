#UnitTest-MappingFunctions.ps1

# include the unittest_function file
. .\unittest_functions.ps1

#include your function file you want to test
. .\sampleFunctions.ps1

# create a function called test_something, be sure to have your test functions have no parameters
function test_eatSomething_taco(){
	$val = eatSomething("taco")
	#check the first value against expected value
	assertTrue $val "yum" "this is the message"
}

function test_eatSomething_trash(){
	$val = eatSomething("trash")
	#check the first value against expected value
	assertTrue $val "gross" "eating trash is gross"
}

###############

#Run the tests by calling Run-Tests. This will run any defined functions where name starts with "test_*"
Run-Tests

#Run a set of tests by calling with a wildcard
Run-Tests "test_*taco"