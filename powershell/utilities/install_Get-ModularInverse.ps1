function global:Get-ModularInverse{
	[CmdletBinding()
		]
	param (
		[parameter(Mandatory=$True,ValueFromPipeline=$True,Position=1,HelpMessage=’integer: the first number’)]
		[int]$num1,
		[parameter(Mandatory=$True,ValueFromPipeline=$True,Position=2,HelpMessage=’integer: the second number’)]
		[int]$num2,
		[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=3,HelpMessage=’integer: the second number’)]
		[bool]$scale=$true)
	Begin
	{
		
	}
	Process
	{
		$start_time = Get-Date
		function invmod_rosetta_code($a,$n){
			# from http://rosettacode.org/wiki/Modular_inverse#PowerShell
	        if ([int]$n -lt 0) {$n = -$n}
    	    if ([int]$a -lt 0) {$a = $n - ((-$a) % $n)}
			$t = 0
			$nt = 1
			$r = $n
			$nr = $a % $n
			while ($nr -ne 0) {
				$q = [Math]::truncate($r/$nr)
				$tmp = $nt
				$nt = $t - $q*$nt
				$t = $tmp
				$tmp = $nr
				$nr = $r - $q*$nr
				$r = $tmp
			}
			if ($r -gt 1) {return -1}
			if ($t -lt 0) {$t += $n}
			display_transaction_time
			return $t
		}
		
		
		function invmod_mine()
		{
			#brute force version I wrote
			1..([Math]::Abs([Math]::Max($num1,$num2))) | % {
				if ( ($num1 * $_) % $num2 -eq 1) {
				display_transaction_time
				return $_
				}
			}
		}
		function invmod_invpy([int]$a, [int]$m)
		{
			# this is the version ported from 'Hacking Secret Ciphers with Python.
			# does not work, perhaps because of differences in order of operation when utilizing multiple assignment, which is not 
			# supported in powershell. From looking at the rosetta code which does work, I see that it assigns results of some calculations as
			# temporary variables, which apparently is not necessary when using multiple assignments in python.
			
			if((Get-GreatestCommonDenominator $a $m) -ne 1)
			{
				return $null
			}
			$u1 = 1
			$u2 = 0
			$u3 = $a
			$v1 = 0
			$v2 = 1
			$v3 = $m
			while($v3 -ne 0)
			{
				$q = [int]($u3 / $v3)
				$v1 = $u1 - $q * $v1
				$v2 = $u2 - $q * $v2
				$v3 = $u3 - $q * $v3
				$u1 = $v1
				$u2 = $v2
				$u3 = $v3
			}
			$retval = $u1 % $m
			display_transaction_time
			return $retval
		}
		function display_transaction_time()
		{
			$stop_time = Get-Date
			$trans_time = $stop_time - $start_time
			Write-Host "Transaction time: $trans_time"
				
		}
 
		
		if ($scale)
		{
		#utlilizes Euclid's extended algorithm
			invmod_rosetta_code $num1 $num2

		}
		else
		{
		#brute force
			invmod_mine $num1 $num2
			
			
		}
		
	}
	End
	{
		#cleanup
	}

}