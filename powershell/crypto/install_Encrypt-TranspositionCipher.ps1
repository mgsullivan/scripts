function global:Encrypt-TranspositionCipher{
[CmdletBinding()]
param (
	[parameter(Mandatory=$True,ValueFromPipeline=$True)]
	[string]$message,
	[parameter(Mandatory=$false)]
	[int]$key=8
	)
	
Begin
{
		
}
Process
{
	function encryptMessage($key_var,$message_var)
	{
		$this_cipher_text = @()
		0..($key_var) | % {
			$this_cipher_text += ""
		}	
		$pointer = $_
		$col = 0
		$message_var.ToCharArray() | % {
			if ($col -eq $key_var) {$col = 0}
			$this_cipher_text[$col] += $_
			$col+=1
		}
			
		
		$retval = -join $this_cipher_text
		Write-Output $retval
	}
	#--Could not support pipeline if validation conducted in 'Begin' block, so doing it here. Uggh. 
	#--If the key is more than half the message length, at least part of the message will not be encrypted
	$cipherText = if($key -ge ($message.Length / 2)){"Please supply a value for key less than half the length for the message to encrypt"}else{encryptMessage $key $message}
	Write-Output $cipherText
		
}
End
{
	
}

}