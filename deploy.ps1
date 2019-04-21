
Push-Location

Remove-Item "public" -Recurse

hugo 

set-location "public\"

Write-S3Object -BucketName tylerrhodes.net -Folder . -Recurse -KeyPrefix \ -CannedACLName public-read -ProfileName HugoProfile

#https://blogs.technet.microsoft.com/heyscriptingguy/2015/11/05/generate-random-letters-with-powershell/
$callerReference = -join ((65..90) + (97..122) | Get-Random -Count 15 | % {[char]$_})

New-CFInvalidation -DistributionId E2S8RAXJEUMBUD -InvalidationBatch_CallerReference $callerReference -Paths_Item "/*" -Paths_Quantity 1 -region "us-east-1" -ProfileName HugoProfile

Pop-Location

