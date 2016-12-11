write-host "loaded unittest_functions.ps1"

function Get-FunctionName($levels=0) { 
    (Get-Variable MyInvocation -Scope ($levels+2)).Value.MyCommand.Name;
}

function assertFalse($val,$val2){
	if ($val -ne $val2){
		write-host -foregroundcolor green ("PASS: "+(Get-FunctionName)+": ""$val"" should NOT equal ""$val2""")
	}else{
		write-host -foregroundcolor red   ("FAIL: "+(Get-FunctionName)+": ""$val"" should NOT equal ""$val2""")
	}
}

function assertTrue($val,$val2,[string]$message = ""){
	$FC = "Red"
	if ([string]"$val" -eq [string]"$val2"){
		if($val.length -gt 40 -or $val2.length -gt 40){
			#write-host -foregroundcolor red   ("FAIL: "+(Get-FunctionName)+": `n`t""$val"" `n`tshould equal `n`t""$val2""")
			$FC = "Green"
			$RES = "PASS"
			$eqmsg = "`n##########################`n""$val"" `n############ equals ############# `n""$val2""`n##########################"
			$eqmsg = "The returned multi-line value matched the expected value"
		}else{
		#write-host -foregroundcolor green ("PASS: "+(Get-FunctionName)+": ""$val"" equals ""$val2""")
			$FC = "Green"
			$RES = "PASS"
			$eqmsg = """$val"" equals ""$val2"""
		}
	}else{
		if($val.length -gt 20 -or $val2.length -gt 20){
			#write-host -foregroundcolor red   ("FAIL: "+(Get-FunctionName)+": `n`t""$val"" `n`tshould equal `n`t""$val2""")
			$RES = "FAIL"
			$eqmsg = "`n##########################`n""$val"" `n############ should equal ############# `n""$val2""`n##########################"
		}else{
			#write-host -foregroundcolor red   ("FAIL: "+(Get-FunctionName)+": ""$val"" should equal ""$val2""")
			$RES = "FAIL"
			$eqmsg = """$val"" should equal ""$val2"""
		}
	}
	if($message){
		$inMessage = ($message).ToString() -f ($RES,(Get-FunctionName),$val,$val2,$eqmsg)
	}
	$assertMessage = "{0}: {1}: {5} {4}".toString() -f ($RES,(Get-FunctionName),$val,$val2,$eqmsg,$inMessage) 
	write-host -foregroundcolor $FC $assertMessage
}

function assertTrueOld($val,$val2){
	if ([string]"$val" -eq [string]"$val2"){
		write-host -foregroundcolor green ("PASS: "+(Get-FunctionName)+": ""$val"" equals ""$val2""")
	}else{
		if($val.length -gt 20 -or $val2.length -gt 20){
			write-host -foregroundcolor red   ("FAIL: "+(Get-FunctionName)+": `n`t""$val"" `n`tshould equal `n`t""$val2""")
		}else{
			write-host -foregroundcolor red   ("FAIL: "+(Get-FunctionName)+": ""$val"" should equal ""$val2""")
		}
	}
}

function assertMessage($passfail,$message,[string]$FuncName="."){
	if($FuncName -eq "."){$funcName = (Get-FunctionName)}
	if ([string]"$passfail" -eq "PASS"){
		write-host -foregroundcolor green ("PASS: "+($funcName)+": "+$message)
	}else{
		write-host -foregroundcolor red   ("FAIL: "+($funcName)+": "+$message)
	}
}

function assertMatchApprovalFile($expectedValue){
	$basePath = "Approvals\"+(Get-FunctionName)
	$approvalFile = $basePath + "approval.txt"
	$val = get-content (Get-FunctionName)
	#set-content "output.unittest.value.txt" $val 
	set-content ($basePath+"expected.txt") $expectedValue
	if($good -eq $val){
		assertMessage "PASS" "Approval file $approvalFile does not match expected $expectedFile"
	}
}

function assertMatchToFile($val,[switch]$diff){
	mkdir "Approvals" -force | out-null
	$f1 = "Approvals\unit."+(Get-FunctionName)+".result.txt"
	$f2 = "Approvals\unit."+(Get-FunctionName)+".expected.txt"
	$message = "comparing file ""$f1"" to expected"
	set-content $f1 $val
	if(test-path $f2){
		$val2 = get-content $f2
	}else{
		write-warning (Get-FunctionName)+": expected file ""$f2"" not found"
	}
	if ([string]"$val" -eq [string]"$val2"){
		write-host -foregroundcolor green ("PASS: "+(Get-FunctionName)+": "+$message)
	}else{
		write-host -foregroundcolor red   ("FAIL: "+(Get-FunctionName)+": "+$message)
		if($diff){
			start winmerge -argumentlist """$f1"" ""$f2"""
		}
	}
}

function assertMatchInFile($val,$val2,[switch]$diff){
	mkdir "Approvals" -force | out-null
	$f1 = "Approvals\unit."+(Get-FunctionName)+".result.txt"
	$f2 = "Approvals\unit."+(Get-FunctionName)+".expected.txt"
	$message = "comparing file ""$f1"" to expected"
	set-content $f1 $val
	set-content $f2 $val2
	if ([string]"$val" -eq [string]"$val2"){
		write-host -foregroundcolor green ("PASS: "+(Get-FunctionName)+": "+$message)
	}else{
		write-host -foregroundcolor red   ("FAIL: "+(Get-FunctionName)+": "+$message)
		if($diff){
			start winmerge -argumentlist """$f1"" ""$f2"""
		}
	}
}

function assertFileExists($filepath,$message=""){
	if(test-path -LiteralPath "$filepath"){
		#$msg = "file found ""$filepath"" $message"
		assertMessage "PASS" "file found ""$filepath"" $message" (Get-FunctionName)
	}else{
		assertMessage "FAIL" "file not found ""$filepath"" $message" (Get-FunctionName)
	}	
}

function assertFileNotExists($filepath,$filepath2,$message){
	write-warning "not implemented"
}

function assertArrayContains($array,$lookfor,$message){
	write-warning "not implemented"
}

function Run-Tests($testMatch=""){
	if($testMatch -eq ""){
		$testMatch = "test_*"
	}else{
		write-host -f black -b yellow " \\ \\ \\ Running Tests matching ""$testMatch"" // // // "
	}
	(Get-ChildItem function:\) | ? {$_.name -like $testMatch} | %{
		$func = $_.name
		&$func
	}
}

