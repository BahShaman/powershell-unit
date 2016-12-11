# Powershell-Unit

## Background
My goal for this scripts was to keep them easy to use and easy to get started with.  I have done entire powershell projects using just a simple assertTrue function and then creating test_ functions in a file and calling them explicitly at the bottom of the file.  

Since then I have added a few more functions, including a function that makes it easy to compare multi-line output, opening winmerge to compare. 

## Usage
Typically I will create a file called UnitTest-SomeFunctions.ps1

### Directory Placement
typical usage is to create unittest_funcitons somewhere within your project.  You will only need to include it in your UnitTest-... files.  

### Including in a file
```PowerShell
    #include (dot source) file UnitTest-SomeFunctions.ps1
	. ./powershell-unit/unittest_functions.ps1 #path to unit test functions
	
	#include your functions you want to test
	. ./myfunctions.ps1
	
	#add any helper functions 
	function helper_getitem($itemid){ 
		#more on this later...
	}
	
	#test function.  Note, there are no params
	function test_something(){
		$val = myfunciton("some input")
		
		assertTrue $val "expected" "message to include"
	} 

```

This will output:
    PASS: test_something: message to include "expected" equals "expected"
or
    FAIL: test_something: message to include "not expected" should equal "expected"

## Function List

Function | Usage 
-------- | -----
assertTrue($val,$expected,$message) | Make Assertion value is Equal expected (in the future will change to expecting value $true)
assertEqual($val,$expected,$message)| Make Assertion value is Equal expected
assertFalse($val,$expected,$message)| Make assertion value is not equal to expected
assertMessage($passfail,$message,$functionname)| Create the assert PASS or FAIL Message
assertMatchInFile($val,$expected,[switch]$diff)| Create a file for each $val and $expected and compare.  If -diff then the files are opened in windiff if they do not match. files are created in a directory called Approvals in the current directory
assertFileExists($filename,$message)| confirm a file exists
assertFileNotExists($filename,$message)| confirm a file does not exist.
Run-Tests($pattern="")|Runs the tests starting with test_ or containing $pattern if specified

## function Examples
TODO: include function examples
	
##Planned Changes
* change the most used assertTrue function to assertEqual
* handle pre-exising approval files (Approval files are files that hold the expected result of a return and is compared against for assertions)
* add function assertArrayContains
* add function assertHashContains
* add function assertLessThan
* add function assertGreaterThan
* create a common way to create pass/fail messages.  Currently Pass fail messages only get written to host using write-host
* create an object containing pass fail outputs
* create a Report for PASS/FAIL output
* setup/teardown functions


##Change Log