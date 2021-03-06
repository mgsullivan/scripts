function global:Start-Test{
	[CmdletBinding()
		]
	param (
		[parameter(Mandatory=$False,ValueFromPipeline=$True,Position=0,HelpMessage=’object: Object with arguments as properties’)]
		[object]$arg_obj=$null,
		[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=1,HelpMessage=’string: Description of test’)]
		[string]$opname,
		[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=2,HelpMessage=’boolean: True to initialize performance monitor’)]
		[boolean]$monitor_performance=$false,
		[parameter(Mandatory=$False,ValueFromPipeline=$False,Position=3,HelpMessage=’string: Path to performance counter init’)]
		[string]$monitor_init="perf_counters.txt"
		
		
		)
		
	Begin
	{
		#input validation
		
		#parse pipe input
		if ($arg_obj -ne $null)
		{
			try
				{
					$opname = $arg_obj.opname	
					$monitor_performance = $arg_obj.monitor_performance
					$monitor_init = $arg_obj.monitor_init
				}
			catch 
				{
					$ErrorMessage = $_.Exception.Message
    				$FailedItem = $_.Exception.ItemName
					Write-Host "Error parsing input. Item: $FailedItem `n ---ERROR-- `n $ErrorMessage"
					Break
				}	
		}
		
		
	}
	Process
	{
		function initialize_test_object()
		{
			$retval = New-Object -TypeName PSObject 
			$retval | Add-Member -MemberType NoteProperty -Value ([System.Diagnostics.Stopwatch]::StartNew()) -Name 'Timer' 
			$retval | Add-Member -MemberType NoteProperty -Name "Op_name" -Value $opname 
			$retval | Add-Member -MemberType NoteProperty -Name "User_name" -Value $env:username 
			$retval | Add-Member -MemberType NoteProperty -Name "Computer" -Value $env:COMPUTERNAME 
			$retval | Add-Member -MemberType NoteProperty -Name "OS" -Value ((Get-CimInstance Win32_OperatingSystem).version) 
			$retval | Add-Member -MemberType NoteProperty -Name "Processor_Architecture" -Value $Env:PROCESSOR_ARCHITECTURE 
			$retval | Add-Member -MemberType NoteProperty -Name "Screenshots" -Value @() 
			$retval | Add-Member -MemberType NoteProperty -Name "Performance_Counters" -Value @()
			Write-Output $retval
			
		}
		function initialize_performance_counters([Object]$test_object)
		{
			try
			{
				cd $PSScriptRoot
				$init_file = Import-Csv -Path $monitor_init
				$init_file | % {
					$this_counter = Get-CounterObject $_
					$test_object.Performance_Counters += $this_counter
				}
			}
			catch
			{
				$ErrorMessage = $_.Exception.Message
    			$FailedItem = $_.Exception.ItemName
				Write-Host "Error initializing performance counters. Item: $FailedItem `n ---ERROR-- `n $ErrorMessage"
				Break
			}
			
		}
		$retval = initialize_test_object 
		if($monitor_performance) {initialize_performance_counters $retval}
		Write-Output $retval
		
	
		
	}
	End
	{
		#cleanup
	}

}