function global:Verb-Noun{
[CmdletBinding(
	DefaultParameterSetName="var",
	SupportsShouldProcess=$False)
	]
param (
	[parameter(Mandatory=$True,ValueFromPipeline=$True,Position=0,HelpMessage=’string: This is the message you want encrypted’)]
	[string]$var
	)
	
Begin
{
	#input validation
	
}
Process
{
	
}
End
{
	
}

}