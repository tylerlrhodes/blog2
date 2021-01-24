

Import-Module AWSPowerShell.NetCore

$nextMarker = $null
$keysPerPage = 50
$objects = $null 
do
{
	$objects = Get-S3Object "tylerrhodes.net" -KeyPrefix / -MaxKey $keysPerPage -Marker $nextMarker
	$nextMarker = $AWSHistory.LastServiceResponse.NextMarker
    $objects | ForEach-Object { Write-Host $_.Key}
} while ($nextMarker)


