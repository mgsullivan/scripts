function global:CheckFor-English{
			
	[CmdletBinding()
		]
	param (
		[parameter(Mandatory=$True,ValueFromPipeline=$True,Position=0,HelpMessage=’string: message you want to check’)]
		[string]$message,
		[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=1,HelpMessage=’string: full path of the dictionary file to use’)]
		[string]$dict_path = "$PSScriptRoot\dictionary.txt",
		[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=2,HelpMessage=’bool: true to force reload of the dictionary’)]
		[bool]$reload = $false,
		[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=3,HelpMessage=’int: the minimum percentage of words matched to the dictionary’)]
		[int]$wordConfidence = 50,
		[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=4,HelpMessage=’int: the minimum percentage of characters that are traditional western characters’)]
		[int]$letterConfidence = 80
		)
		
	Begin
	{
		if (Test-Path $dict_path) {} else {Throw "Invalid dictionary path $dict_path"}
		if ($reload) 
		{
			$global:cfe_dict = $null
		}
		if ($global:cfe_dict -eq $null) 
		{ 
			$global:cfe_dict = @{}
			Get-Content -Path $dict_path  | %{$global:cfe_dict.add($_,$null) | Out-Null}			
		}
		
	}
	Process
	{
		$UPPERLETTERS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
		$LETTERS_AND_SPACES = $UPPERLETTERS + $UPPERLETTERS.ToLower() + ' `t`n'
	
		function getEnglishCount($message)
		{
			$this_message = removeNonLetters $message.ToUpper()
			$possibleWords = $this_message -split ' '
			if ($possibleWords.Count -eq 0 -or $possibleWords -eq $null)
			{
				Write-Output 0.0
				return
			}
			$matches = 0
			$possibleWords | % {if ($global:cfe_dict.ContainsKey($_)) {$matches += 1}}
			$retVal = $matches / $possibleWords.Count * 100
			Write-Output $retVal
			
		}
		function removeNonLetters($message)
		{
			$lettersOnly = @()
			$message.ToCharArray() | % {if ($LETTERS_AND_SPACES -like "*$_*"){$lettersOnly+=$_}}
			$retval = -join $lettersOnly
			Write-Output $retval
		}
		function determineIfEnglish($message,[int]$wordPercentageMinimum,[int]$letterPercentageMinimum)
		{
			$wordsMatchPercentage = getEnglishCount $message
			$wordsMatch = $wordsMatchPercentage -ge $wordPercentageMinimum
			$letterPercentage = (removeNonLetters $message).Length / $message.Length * 100
			$letterMatch= $letterPercentage -ge $letterPercentageMinimum
			$retVal = $wordsMatch -and $letterMatch
			Write-Output $retVal
		}
		
		$retval = determineIfEnglish $message $wordConfidence $letterConfidence
		Write-Output $retval
	}
	End
	{
		#cleanup
	}

}