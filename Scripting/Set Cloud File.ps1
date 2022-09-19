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
    [string]$ResourceGroupName = 'psopl'
)