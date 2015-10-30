function global:ConvertTo-TranspositionCipher{
[CmdletBinding(
	DefaultParameterSetName="var",
	SupportsShouldProcess=$False)
	]
param (
	[parameter(Mandatory=$True,ValueFromPipeline=$True,Position=0,HelpMessage=’string: This is the message you want encrypted’)]
	[string]$message,
	[parameter(Mandatory=$false,ValueFromPipeline=$True,Position=1,HelpMessage=’string: This is the key’)]
	[int]$key=8
	
	)
	
Begin
{
	#If the key is more than twice the message length, at least part of the message will not be encrypted
	if($key -ge ($var.Length / 2)){throw "Please supply a value for key less than twice the length for the message to encrypt"}
	
}
Process
{
	function encryptMessage($key_var,$message_var)
	{
		$message_array = 
		$this_cipher_text = @('') * ($key_var + 1)
		0..($key_var) | % {
		
			$pointer = $_
			while($pointer -lt $message_var.Length)
			{
				$this_cipher_text[$_] += $message_var.ToCharArray()[$pointer]
				$pointer += $key_var
			}
			
		}
		$retval = -join $this_cipher_text
		Write-Output $retval
	}
	$cipherText = encryptMessage $key $message
	Write-Output $cipherText	
}
End
{
	
}

}