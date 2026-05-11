Param(
    [Hashtable] $parameters = @{},
    [string] $project = ""
)

# Demonstrates the new AL-Go BuildInitialize override (independent of BcContainerHelper).
# Runs as the first step of the build workflow, immediately after Checkout and
# *before* Read settings — so AL-Go settings, secrets and most environment
# variables are not yet available at this point.

Write-Host "BuildInitialize override executing for project '$project'."
if ($parameters -and $parameters.Count -gt 0) {
    Write-Host "Parameters: $($parameters | ConvertTo-Json -Compress -Depth 5)"
}
else {
    Write-Host "No parameters were passed to the override."
}

$sleepSeconds = Get-Random -Minimum 0 -Maximum 61
Write-Host "Sleeping for $sleepSeconds seconds..."
Start-Sleep -Seconds $sleepSeconds
Write-Host "Done sleeping."
