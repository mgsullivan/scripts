function global:Encrypt-File{
[CmdletBinding(
	DefaultParameterSetName="message",
	SupportsShouldProcess=$False)
	]
param (
	[parameter(Mandatory=$True,ValueFromPipeline=$True,Position=0,HelpMessage=’path of the file you wish to encrypt’)]
	[string]$filename,
	[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=1,HelpMessage=’true to decrypt’)]
	[boolean]$decrypt=$false,
	[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=2,HelpMessage=’transposition, caesar, or reverse’)]
	[string]$cipher="transposition",
	[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=3,HelpMessage=’integer’)]
	[int]$key=10,
	[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=4,HelpMessage=’where you want the encrypted file to be placed’)]
	[string]$output_filename)
	
Begin
{
	..\install_crypto.ps1
}
Process
{
	###  FYI, this is intended to encrypt text files, as part of a class exercise for encryption. Does not preserve ###
	### line breaks and other non-characters very well, not suitable for general use.  ###

	if (Test-Path $filename){}else{Write-Output "$filename does not exist";exit}
	if ($output_filename -eq ""){$output_filename = $filename + ".encrypted"}
	if (Test-Path $output_filename)
	{
		$response = Read-Host "$output_filename already exists. Overwrite? (C)ontinue or (Q)uit" 
		if ($response.toLower().StartsWith("c"))
			{} 
		else 
			{exit}
	}
	$content = -join (Get-Content -Path $filename)
	Write-Host "Processing..."
	$start_time = Get-Date
	$crypto_content = Switch($cipher.ToLower())
	{
		"transposition"{Encrypt-TranspositionCipher -message $content -key $key -decrypt $decrypt }
		"caesar"{Encrypt-CaesarCipher -var $content -key $key -decrypt $decrypt }
		"reverse"{Encrypt-ReverseCipher -message $content}
	}
	$end_time = Get-Date
	$transaction_time = $end_time - $start_time
	Write-Host "Transaction completed, total time:$transaction_time."
	$crypto_content | Out-File -FilePath $output_filename -Force
	Write-Output "Encrypted file saved to $output_filename"
}
End
{
	
}

}