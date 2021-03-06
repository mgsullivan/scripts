function global:BruteForce-TranspositionCipher{
	[CmdletBinding()]
	param (
		[parameter(Mandatory=$True,ValueFromPipeline=$True,Position=0,HelpMessage=’string: the message you want to brute force’)]
		[string]$message
		)
		
	Begin
	{
		cd $PSScriptRoot
		..\install_crypto.ps1
		..\Install_utilities.ps1
		
	}
	Process
	{
		function hackTransposition($this_message)
		{
			Write-Host "Starting brute force of transposition cipher.`n"
			Write-Host "Press CTRL-C to stop..."
			1..$this_message.Length | % {
					$decrypted_text = Encrypt-TranspositionCipher -message $this_message -key $_ -decrypt $true
					if(CheckFor-English -message $decrypted_text) 
					{
						$snip = if($decrypted_text.Length -gt 100){$decrypted_text.Substring(0,100)}else{$decrypted_text}
						$prompt_text = "Possible crack found using key $_. Decrypted text is $snip(...). Continue brute force? [Y|N]"
						$continue = "" 
						$continue = Read-Host -Prompt $prompt_text
						if($continue.ToUpper().StartsWith("N"))
						{
							Write-Output $decrypted_text
							break
						}
						
					}
					
					
				}
			Write-Output $null
		}
		$brute_force_crack = hackTransposition $message
		if($brute_force_crack -eq $null)
		{
			Write-Output "Failed to crack code."
		}
		else
		{
			Write-Output $brute_force_crack
		}
		
	}
	End
	{
		#cleanup
	}

}