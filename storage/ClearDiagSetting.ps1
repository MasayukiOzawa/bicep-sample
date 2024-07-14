$resourceGroupName = "rg-bicep"
$resources = Get-AzResource -ResourceGroupName $resourceGroupName
foreach ($resource in $resources){
    try{
        $diag = Get-AzDiagnosticSetting -ResourceId $resource.ResourceId -ErrorAction Stop
        Write-Host "$($resource.Name) Delete Start."
        if($resource.ResourceType -eq "Microsoft.Storage/storageAccounts") {
            Get-AzDiagnosticSetting -ResourceId $($resource.ResourceId  + '/blobServices/default') | %{
                Remove-AzDiagnosticSetting -ResourceId $($resource.ResourceId  + '/blobServices/default')  -Name $_.Name
            }
            Get-AzDiagnosticSetting -ResourceId $($resource.ResourceId  + '/queueServices/default') | %{
                Remove-AzDiagnosticSetting -ResourceId $($resource.ResourceId  + '/queueServices/default')  -Name $_.Name
            }
            Get-AzDiagnosticSetting -ResourceId $($resource.ResourceId  + '/tableServices/default') | %{
                Remove-AzDiagnosticSetting -ResourceId $($resource.ResourceId  + '/tableServices/default')  -Name $_.Name
            }
            Get-AzDiagnosticSetting -ResourceId $($resource.ResourceId  + '/fileServices/default') | %{
                Remove-AzDiagnosticSetting -ResourceId $($resource.ResourceId  + '/fileServices/default')  -Name $_.Name
            }
        }
        $diag | %{ Remove-AzDiagnosticSetting -Name $_.Name -ResourceId $resource.ResourceId }
    }catch{
        Write-Host $_
    }
}
 