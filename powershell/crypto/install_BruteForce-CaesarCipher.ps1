function global:BruteForce-CaesarCipher{
[CmdletBinding(
	DefaultParameterSetName="var",
	SupportsShouldProcess=$False)
	]
param (
	[parameter(Mandatory=$True,ValueFromPipeline=$True,Position=0,HelpMessage=’string: This is the message you want encrypted’)]
	[string]$var,
	[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=1,HelpMessage=’boolean: true to decrypt’)]
	[string]$mode = $false,
	[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=2,HelpMessage=’integer: this is the number you want to use as the key’)]
	[int]$key = 13,
	[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=4,HelpMessage=’integer: ascii value of lower bound of letter range’)]
	[int]$fca = 33,
	[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=5,HelpMessage=’integer: ascii value of upper bound of letter range’)]
	[int]$lca = 123,
	[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=6,HelpMessage=’integer: ascii value of upper bound of symbol range’)]
	[int]$fcs = 33,
	[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=7,HelpMessage=’integer: ascii value of upper bound of symbol range’)]
	[int]$lcs = 43,
	[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=8,HelpMessage=’boolean: true to replace spaces with random symbols’)]
	[Boolean]$substitute_spaces=$false
	)
	
Begin
{	

	#this requires ConvertTo-CaesarCipher commandlet
	try {Get-Command -Name ConvertTo-CaesarCipher | Out-Null}
	catch 
	{
		Throw "This commandlet required ConvertTo-CaesarCipher, which is not presently installed"
		Exit
	}
	
	#input validation
	
}
Process
{
	$decrypts = @()
	0..26 | % {
		$decrypt = ConvertTo-CaesarCipher -var $var -key $_ -fca $fca -lca $lca -fcs $fcs -lcs $lcs -mode $mode -substitute_spaces $substitute_spaces
		$decrypts+= New-Object psobject -Property @{
 			Key = $_
 			Decrypt = $decrypt}
	}
	Write-Output $decrypts | Format-Table -AutoSize
	
}
End
{
	
}

}
