function global:Decrypt-TranspositionCipher{
[CmdletBinding(
	DefaultParameterSetName="var",
	SupportsShouldProcess=$False)
	]
param (
	[parameter(Mandatory=$True,ValueFromPipeline=$True,Position=0,HelpMessage=’string: This is the message you want encrypted’)]
	[string]$message,
	[parameter(Mandatory=$False,ValueFromPipeline=$false,Position=1,HelpMessage=’string: This is the key’)]
	[string]$key=8
	)
	
Begin
{
	#input validation
	
}
Process
{
	function decryptCipher([int]$this_key, [string]$this_message)
	{
		$numOfColumns = [Math]::Ceiling($this_message.Length / $this_key)
		$numOfRows = $this_key
		$numOfShadedBoxes = $numOfColumns * $numOfRows - $this_message.Length
		$plaintext = @()
		0..$numOfColumns | % {$plaintext += ""}
		$col = 0
		$row = 0
		$this_message.ToCharArray() | % {
			if($col -eq $numOfColumns -or ($col -eq ($numOfColumns - 1) -and $row -ge ($numOfRows - $numOfShadedBoxes)))
			{
				$col = 0
				$row += 1
			}
			$plaintext[$col] += $_
			$col += 1
			
		}
		$function_retval = -join $plaintext 
		Write-Output $function_retval
		
	}
	
	$retval = decryptCipher $key $message
	Write-Output $retval
	
}
End
{
	
}

}