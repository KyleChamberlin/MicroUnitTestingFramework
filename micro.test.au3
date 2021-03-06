Func _test_($testName)
	$oClassObject = _AutoItObject_Class()
	$oClassObject.Create()
    $dicSteps = ObjCreate("Scripting.Dictionary")

	With $oClassObject
		.AddMethod("addStep","addStep")
		.AddMethod("countSteps","countSteps")
		.AddMethod("assertTrue","assertTrue")
        .AddMethod("stepPassed","stepPassed")
        .AddMethod("stepFailed","stepFailed")
        .AddMethod("duration","duration")
	EndWith

	With $oClassObject
		.AddProperty("_type_", $ELSCOPE_PUBLIC, "_test_") ;Object type
		.AddProperty("name", $ELSCOPE_PUBLIC,$testName)
		.AddProperty("steps", $ELSCOPE_PUBLIC, $dicSteps) ;Dictionary with test case steps
		.AddProperty("stepCount",$ELSCOPE_PRIVATE,0)
		.AddProperty("pass",$ELSCOPE_PUBLIC,True)
        .AddProperty("testResult",$ELSCOPE_PUBLIC,"Passed") ;0 Failed - 1 OK
		.AddProperty("testStepsFailed",$ELSCOPE_PUBLIC,0)
		.AddProperty("testStepsPassed",$ELSCOPE_PUBLIC,0)
        .AddProperty("beginTime",$ELSCOPE_PRIVATE,_NowCalc())
        .AddProperty("endTime",$ELSCOPE_PRIVATE,_NowCalc())
	EndWith

	Return $oClassObject.Object
EndFunc

Func assertTrue($this, $assertText, $assertion)
	$this.addStep($assertText, $assertion)
    $this.endTime = _NowCalc()
EndFunc

Func assertFalse($this, $assertText, $falseAssertion)
    $this.assertTrue($assertText,Not $falseAssertion)
EndFunc

Func addStep($this,$stepText,$assertion)
	Local $step[2] = [$stepText,$assertion]
    $this.stepCount = $this.stepCount + 1
    $this.steps.Add($this.stepCount, $step)

    If $assertion Then
        $this.stepPassed()
    Else
        $this.stepFailed()
	EndIf
EndFunc

Func stepFailed($this)
    $this.pass = False
    $this.testResult = "Failed"
	$this.testStepFailed = $this.testStepFailed + 1
EndFunc

Func stepPassed($this)
    $this.testStepPassed = $this.testStepPassed + 1
EndFunc

Func duration($this)
    Return $this.endTime - $this.beginTime
EndFunc