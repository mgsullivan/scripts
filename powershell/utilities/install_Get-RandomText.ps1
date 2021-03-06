function global:Get-RandomText{
	[CmdletBinding()
		]
	param (
		[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=0,HelpMessage=’datatype: Description’)]
		[int]$Length=20,
		[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=0,HelpMessage=’datatype: Description’)]
		[int]$CharStart=33,
		[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=0,HelpMessage=’datatype: Description’)]
		[int]$CharEnd=126
		)
		
	Begin
	{
		#input validation
		
	}
	Process
	{
		$CharStart..$CharEnd | % {$set+=([char]$_).ToString()}
		$result=""
		1..$Length | %{$result += ($set.ToCharArray())[(Get-Random -Minimum 0 -Maximum ($Length - 1))]}
		Write-Output $result	
	}
	End
	{
		#cleanup
	}

}