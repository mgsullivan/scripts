function global:Encrypt-CaesarCipher
{
#traditional CaesarCipher with optional switch to replace spaces with symbols to make it look less like a Caesar Cipher.
#Still ridiculously insecure, only created this as a class exercise for study in cryptography
#This has big problems due to powershell issues 

[CmdletBinding(
	DefaultParameterSetName="var",
	SupportsShouldProcess=$False)
	]
	param (
		[parameter(Mandatory=$True,ValueFromPipeline=$True,Position=0,HelpMessage=’string: This is the message you want encrypted’)]
		[string]$var,
		[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=1,HelpMessage=’boolean: true to decrypt’)]
		[string]$decrypt = $false,
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
		#input validation
		if ($fcs -ge $lcs) { Throw "The lower bound of the symbol range cannot be less than or equal to the upper bound"}
		if ($fca -ge $lca) { Throw "The lower bound of the character range cannot be less than or equal to the upper bound"}
		
	}
	Process
	{
	$var = $var.ToUpper()
		$LETTERS = -join ($fca..$lca | % { [char]$_ })
		$SYMBOLS = -join ($fcs..$lcs | % { [char]$_ })
		$translate=""
	
	[Char[]]$var | % {
		if ($LETTERS.Contains([string]$_)) 
		{
			$mode_int = if ($decrypt){-1} else {1}
			$num = $LETTERS.IndexOf([string]$_) + ($mode_int * $key)
			if($num -gt $LETTERS.Length) { $num -= $LETTERS.Length }
			elseif ($num -lt 0) { $num += $LETTERS.Length }
			$translate += $LETTERS[$num]
		}
		elseif ($substitute_spaces -and $_ -eq ' ')
		{	
			$num = Get-Random -Minimum $fcs -Maximum $lcs
			$translate += $SYMBOLS[$num]
		}
		else
		{
			$translate += [string]$_
		}
	}
	Write-Output $translate
	}
	End
	{
		
	}

}