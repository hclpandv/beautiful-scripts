<#
Credit: Rashi Bhalla
#>

Connect-MgGraph -Scopes 'Application.Read.All'

$Applications = Get-MgApplication -All
$Logs = @()

foreach ($App in $Applications) {
    $AppName       = $App.DisplayName
    $AppID         = $App.Id
    $ApplID        = $App.AppId
    $AppCreateTime = $App.CreatedDateTime

    $Owner         = Get-MgApplicationOwner -ApplicationId $App.Id
    $Username      = $Owner.AdditionalProperties.userPrincipalName -join ';'
    $OwnerID       = $Owner.Id -join ';'

    if ($null -eq $Owner.AdditionalProperties.userPrincipalName) {
        $Username = @(
            $Owner.AdditionalProperties.displayName
            '**<This is an Application>**'
        ) -join ' '
    }

    if ($null -eq $Owner.AdditionalProperties.displayName) {
        $Username = '<<No Owner>>'
    }

    $AppCreds = Get-MgApplication -ApplicationId $AppID | Select-Object PasswordCredentials, KeyCredentials
    $Secrets  = $AppCreds.PasswordCredentials
    $Certs    = $AppCreds.KeyCredentials

    ############################################
    $Logs += [PSCustomObject]@{
        'ApplicationName'        = $AppName
        'ApplicationID'          = $ApplID
        'AppCreatedTime'         = $AppCreateTime
        'Secret Name'            = $Null
        'Secret Description'     = $Null
        'Secret Start Date'      = $Null
        'Secret End Date'        = $Null
        'Certificate Name'       = $Null
        'Certificate Start Date' = $Null
        'Certificate End Date'   = $Null
        'Owner'                  = $Username
        'Owner_ObjectID'         = $Null
    }
    ############################################

    foreach ($Secret in $Secrets) {
        $StartDate         = $Secret.StartDateTime
        $EndDate           = $Secret.EndDateTime
        $SecretName        = $Secret.DisplayName
        $SecretDescription = $Secret.SecretText

        $Logs += [PSCustomObject]@{
            'ApplicationName'        = $AppName
            'ApplicationID'          = $ApplID
            'AppCreatedTime'          = $AppCreateTime
            'Secret Name'             = $SecretName
            'Secret Description'      = $SecretDescription
            'Secret Start Date'       = $StartDate
            'Secret End Date'          = $EndDate
            'Certificate Name'        = $Null
            'Certificate Start Date'  = $Null
            'Certificate End Date'    = $Null
            'Owner'                   = $Username
            'Owner_ObjectID'          = $OwnerID
        }
    }

    foreach ($Cert in $Certs) {
        $StartDate = $Cert.StartDateTime
        $EndDate   = $Cert.EndDateTime
        $CertName  = $Cert.DisplayName

        $Logs += [PSCustomObject]@{
            'ApplicationName'        = $AppName
            'ApplicationID'          = $ApplID
            'AppCreatedTime'          = $AppCreateTime
            'Secret Name'             = $Null
            'Secret Description'      = $Null
            'Secret Start Date'       = $Null
            'Secret End Date'         = $Null
            'Certificate Name'        = $CertName
            'Certificate Start Date'  = $StartDate
            'Certificate End Date'    = $EndDate
            'Owner'                   = $Username
            'Owner_ObjectID'          = $OwnerID
        }
    }
}

$Path = 'C:\temp\report-rashi\Azure application recertification\UAT.csv'
$Logs | Export-Csv $Path -NoTypeInformation -Encoding UTF8
