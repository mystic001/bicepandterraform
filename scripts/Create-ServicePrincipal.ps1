[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$SubscriptionId,
    
    [Parameter(Mandatory = $true)]
    [string]$TenantId,
    
    [Parameter(Mandatory = $true)]
    [string]$SpnName,
    
    [Parameter(Mandatory = $true)]
    [ValidateSet('Contributor', 'Owner', 'Reader')]
    [string]$RoleName
)

try {
    # Connect to Azure
    Write-Host "Connecting to Azure..."
    Connect-AzAccount -ServicePrincipal `
        -Tenant $TenantId `
        -Subscription $SubscriptionId

    # Create Azure AD App Registration
    Write-Host "Creating Azure AD App Registration..."
    $app = New-AzADApplication -DisplayName $SpnName

    # Create Service Principal
    Write-Host "Creating Service Principal..."
    $spn = New-AzADServicePrincipal -ApplicationId $app.AppId

    # Create client secret
    Write-Host "Creating Client Secret..."
    $endDate = [System.DateTime]::Now.AddYears(2)
    $secret = New-AzADAppCredential -ApplicationId $app.AppId -EndDate $endDate

    # Assign role
    Write-Host "Assigning Role..."
    New-AzRoleAssignment -ApplicationId $app.AppId `
        -RoleDefinitionName $RoleName `
        -Scope "/subscriptions/$SubscriptionId"

    # Mask sensitive output
    Write-Host "::add-mask::$($secret.SecretText)"
    Write-Host "Service Principal created successfully!"
    
    # Return PSObject
    [PSCustomObject]@{
        clientId = $app.AppId
        clientSecret = $secret.SecretText
    }
}
catch {
    Write-Error "Error creating service principal: $_"
    throw $_
} 