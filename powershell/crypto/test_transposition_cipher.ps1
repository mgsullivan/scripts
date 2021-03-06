cd $PSScriptRoot
..\install_crypto.ps1
..\Utilities\install_Get-RandomText.ps1
1..20 | % {
	
	
	$message = Get-RandomText -Length (Get-Random -Minimum 10 -Maximum 50)
	1..(($message.Length / 2) - 1) | % {
		$encrypted = Encrypt-TranspositionCipher -message $message -key $_
		$decrypted = Decrypt-TranspositionCipher -message $encrypted -key $_
		if ($message -ne $decrypted)
		{
			Write-Output 'Mismatch with key $_ and message $message.'
			Write-Output $decrypted
			exit
		}
	}
}
Write-Output "Transposition Cipher Test passed"

