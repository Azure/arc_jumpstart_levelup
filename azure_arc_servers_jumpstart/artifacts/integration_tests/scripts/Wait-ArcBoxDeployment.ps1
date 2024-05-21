param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    [Parameter(Mandatory=$true)]
    [string]$githubAccount,
    [Parameter(Mandatory=$true)]
    [string]$githubBranch
)

Write-Host "Starting VM Run Command to wait for deployment and retrieve Pester test results from ArcBox-Client in resource group $ResourceGroupName"

$Location = (Get-AzVM -ResourceGroupName $ResourceGroupName).Location
Set-AzVMRunCommand -ResourceGroupName $ResourceGroupName -VMName ArcBox-Client -RunCommandName RetrievePesterResults -Location $Location -SourceScriptUri "https://raw.githubusercontent.com/$githubAccount/azure_arc/$githubBranch/azure_jumpstart_arcbox/artifacts/integration_tests/scripts/Send-PesterResult.ps1" -AsyncExecution

do {
    $job = Get-AzVMRunCommand -ResourceGroupName $ResourceGroupName -VMName ArcBox-Client -RunCommandName RetrievePesterResults -Expand InstanceView

    Write-Host "Instance view of job:" -ForegroundColor Green
    $job.InstanceView
    Start-Sleep -Seconds 60

} while ($job.InstanceView.ExecutionState -eq "Running")

Write-Host "Job completed" -ForegroundColor Green
$job