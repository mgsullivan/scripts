# this is original. Basically a wrapper around the Get-Counter commandlet to allow for better control and reporting


function global:Get-CounterObject{
	[CmdletBinding()
		]
	param (
		[parameter(Mandatory=$False,ValueFromPipeline=$True,Position=0,HelpMessage=’object: Object with arguments as properties’)]
		[object]$arg_obj=$null,
		[parameter(Mandatory=$false,ValueFromPipeline=$false,Position=1,HelpMessage=’string: Name of counter to monitor’)]
		[string]$counter_name="Processor(_Total)\% Processor Time",
		[parameter(Mandatory=$false,ValueFromPipeline=$false,Position=2,HelpMessage=’int: frequency of polling’)]
		[int]$SampleInterval=10,
		[parameter(Mandatory=$false,ValueFromPipeline=$false,Position=3,HelpMessage=’long: the maximum number of samples to collect’)]
		[long]$MaxSamples=10,
		[parameter(Mandatory=$false,ValueFromPipeline=$false,Position=4,HelpMessage=’boolean: true to keep polling until job is stopped ’)]
		[bool]$Continuous=$true,
		[parameter(Mandatory=$false,ValueFromPipeline=$false,Position=5,HelpMessage=’string: name of computer from which to receive counters’)]
		[string]$ComputerName=$env:computername,
		[parameter(Mandatory=$false,ValueFromPipeline=$false,Position=6,HelpMessage=’string: common parameters’)]
		[string]$CommonParameters = $null
		)
	Begin
	{
		#input validation
		
		#parse arg_obj
		if($arg_obj -ne $null)
		{
			try
			{
				$counter_name = [String]$arg_obj.Counter
				$SampleInterval = [int]$arg_obj.SampleInterval
				$MaxSamples = [long]$arg_obj.MaxSamples
				$Continuous = [Boolean]$arg_obj.Continuous
				$ComputerName = [String]$arg_obj.ComputerName
				$CommonParameters = [String]$arg_obj.CommonParameters
			
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
		function initialize_counter_object()
		{
			$retval = New-Object -TypeName PSObject 
			$retval | Add-Member -MemberType NoteProperty -Name "Job" -Value $null
			$counter_script_continuous = "{Get-Counter ""$counter_name"" -SampleInterval $SampleInterval -ComputerName $ComputerName -Continuous }"
			$counter_script_static = "{Get-Counter ""$counter_name"" -SampleInterval $SampleInterval -MaxSamples $MaxSamples -ComputerName $ComputerName }"
			$counter_script_str = if($Continuous){$counter_script_continuous}else{$counter_script_static}
			$counter_script = [System.Management.Automation.ScriptBlock]::Create($counter_script_str)
			$start_job = {$This.Job = Start-Job -ScriptBlock $This.Script}
			$stop_job = {Stop-Job -Job $This.Job}
			$read_job = {Receive-Job -Job $This.Job -Keep}
			$get_list = { $This.results = $This.Read() | % {New-Object -TypeName PSObject -Property @{TimeStamp=$_.timestamp;Reading=(($_.readings.split(':'))[1]).Replace("`n","")}}}
			$retval | Add-Member -MemberType ScriptProperty -Name "Script" -Value $counter_script
			$retval | Add-Member -MemberType ScriptMethod $start_job -Name "Start"
			$retval | Add-Member -MemberType ScriptMethod $stop_job -Name "Stop" 
			$retval | Add-Member -MemberType ScriptMethod $read_job -Name "Read" 
			$retval | Add-Member -MemberType NoteProperty  -Name "Results" -Value $null 
			$retval | Add-Member -MemberType ScriptMethod $get_list -Name "Get_List"		
			Write-Output $retval
		}
		$retval = initialize_counter_object
		Write-Output $retval
	}
	End
	{
		#cleanup
	}

}