function global:CONVERTTO-REVERSECIPHER{
param ([string]$message)
$translate=""
$i = $message.Length - 1
while($i -ge 0){$translate += $message[$i];$i -= 1}
Write-Output $translate
}