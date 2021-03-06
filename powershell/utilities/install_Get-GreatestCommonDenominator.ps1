function global:Get-GreatestCommonDenominator{
	[CmdletBinding()
		]
	param (
		[parameter(Mandatory=$True,ValueFromPipeline=$True,Position=1,HelpMessage=’integer: the first number’)]
		[int]$num1,
		[parameter(Mandatory=$True,ValueFromPipeline=$True,Position=2,HelpMessage=’integer: the second number’)]
		[int]$num2)
	Begin
	{
		
	}
	Process
	{
		#yes, I know there are sys.math functions that do this
		while($num1 -ne 0)
		{
			$mod_result = $num2 % $num1
			$num2 = $num1
			$num1 = $mod_result
		}
		Write-Output $num2
	}
	End
	{
		#cleanup
	}

}