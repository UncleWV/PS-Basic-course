<#
.SYNOPSIS
upload given file to azure blob storage and return url as string
.PARAMETER path
path to local file that will be uploaded
.PARAMETER Name

#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)][string]$LocalFile,
    [Parameter(Mandatory=$true)][string]$Name,
    [string]$ResourceGroupName = 'opleiding_ps',
    [string]$AzLocation = 'westeurope',
    [string]$StorageAccountName = 'psoplblobs',
    [string]$StorageAccountSKU = 'Standard_LRS',
    [string]$StorageContainerName = 'default'
)

#Get-ResourceGroup
Try {
    $ResourceGroup = Get-AzResourceGroup `
        -Name $ResourceGroupName `
        -ErrorAction Stop
}
Catch {
    $ResourceGroup = New-AzResourceGroup `
        -Name $ResourceGroupName `
        -Location $AzLocation
}
$ResourceGroup

# Get storage account, if it doesn't exist create
Try {
    $StorageAccount = Get-AzStorageAccount `
        -Name $StorageAccountName `
        -ResourceGroupName $ResourceGroup.ResourceGroupName
        -ErrorAction Stop
}
Catch {
    $StorageAccount = New-AzStorageAccount `
        -ResourceGroupName $ResourceGroup.ResourceGroupName `
        -Name $StorageAccountName `
        -Location $AzLocation `
        -SkuName $StorageAccountSKU  
}
$StorageAccount

# Get storage container, if it doesn't exist create
Try {
    $StorageContainer = Get-AzStorageContainer `
        -Name $StorageContainerName `
        -Context $StorageAccount.Context `
        -ErrorAction Stop
}
Catch {
    $StorageContainer = New-AzStorageContainer `
        -Name $StorageContainerName `
        -Permission blob `
        -Context $StorageAccount.Context
}
$StorageContainer

# Upload file to new blob on Azure
$Blob = Set-AzStorageBlobContent `
    -File $LocalFile `
    -Blob $Name `
    -Container $StorageContainer.Name `
    -Context $StorageContainer.Context 

# Get the blob's URL
$URL = $Blob.ICloudBlob.Uri.AbsoluteUri
Write-Host "URL:$URL"