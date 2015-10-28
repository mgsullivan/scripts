function global:ConvertTo-CaesarCipher
{
[CmdletBinding(
	DefaultParameterSetName="message",
	SupportsShouldProcess=$False)
	]
	param (
		[parameter(Mandatory=$True,ValueFromPipeline=$True,Position=0,HelpMessage=’string: This is the message you want encrypted’)]
		[string]$var="default",
		[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=1,HelpMessage=’boolean: true to decrypt’)]
		[string]$mode = $false,
		[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=2,HelpMessage=’integer: this is the number you want to use as the key’)]
		[string]$key=13,
		[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=3,HelpMessage=’boolean: substitute spaces with non-punctuation symbols’)]
		[string]$substitute_spaces=$false,
		[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=4,HelpMessage=’integer: ascii value of lower bound of letter range’)]
		[string]$fca=65,
		[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=5,HelpMessage=’integer: ascii value of upper bound of letter range’)]
		[string]$lca=90,
		[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=6,HelpMessage=’integer: ascii value of upper bound of symbol range’)]
		[string]$fcs=33,
		[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=7,HelpMessage=’integer: ascii value of upper bound of symbol range’)]
		[string]$lcs=43)
	Begin
	{
		#input validation
		if ($fcs -ge $lcs) { Throw "The lower bound of the symbol range cannot be less than or equal to the upper bound"}
		if ($fca -ge $lca) { Throw "The lower bound of the character range cannot be less than or equal to the upper bound"}
		
	}
	Process
	{
		
		$LETTERS = $fca..$lca | % { [char]$_ }
		$SYMBOLS = $fcs..$lcs | % { [char]$_ }
		$translate=""
		[Char[]]$var | % {
				if ($LETTERS -contains $_) 
				{
					$mode_int = [int]$mode
					$num = $LETTERS.IndexOf([string]$_) * ($mode * -1 )
					if($num -gt $lca) { $num -= $LETTERS.Count }
					elseif ($num -lt $fca) { $num += $LETTERS.Count }
					$translate += $LETTERS[$num]
				}
				elseif ($substitute_spaces -and $_ -eq ' ')
				{	
					$num = Get-Random -Minimum $fcs -Maximum $lcs
					$translate += $SYMBOLS[$num]
				}
				else
				{
					$translate += $_
				}
			}
		Write-Output $translate
	}
	End
	{
		
	}

}