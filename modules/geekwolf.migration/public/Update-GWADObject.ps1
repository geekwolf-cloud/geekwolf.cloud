<#
.SYNOPSIS
    Updates the user principal name and organizational unit of an AD object or collection of AD objects

.DESCRIPTION
    This function updates the UserPrincipalName and OrganizationalUnit of user accounts, groups and devices. It supports two modes of operation:
    - You can provide individual parameters for a single object
    - You can provide a collection of objects, each containing the properties to be updated.

.PARAMETER Identity
    The identity of the object.  This can be a UserPrincipalName, a SamAccountName or a Name.  The function will try to find a unique match for that in the current domain,  This parameter is used in the 'ByParameters' parameter set.

.PARAMETER UserPrincipalName
    The new UserPrincipalName for the object. This parameter is used in the 'ByParameters' parameter set.

.PARAMETER OrganizationalUnit
    The new Organizational Unit to which the object should be moved. This parameter is used in the 'ByParameters' parameter set.

.PARAMETER InputObject
    A collection of objects where each object has properties 'Identity', 'UserPrincipalName', and 'OrganizationalUnit'. 
    This parameter is used in the 'ByObject' parameter set and supports pipeline input.

.PARAMETER Force
    Force updating the object so that it doesn't ask you to confirm each one (alternative to -Confirm:$False)

.EXAMPLE
    Update-GWADObject -Identity "user1@domain.com" -UserPrincipalName "user1.new@domain.com" -OrganizationalUnit "OU=NewOU,DC=domain,DC=com"
        
    Description:
    This example updates a single object's User Principal Name and moves the object to a new Organizational Unit.

.EXAMPLE
    $objects = @(
        [PSCustomObject]@{Identity = "user2@domain.com"; UserPrincipalName = "user2.new@domain.com"; OrganizationalUnit = "OU=NewOU,DC=domain,DC=com"},
        [PSCustomObject]@{Identity = "Group Name"; UserPrincipalName = $null; OrganizationalUnit = "OU=NewOU,DC=domain,DC=com"}
    )
    $objects | Update-GWADObject

Description:
    This example takes a collection of objects from a pipeline and updates their User Principal Name and/or Organizational Unit

.NOTES
    You can use this function in two ways: by specifying individual parameters for one object or by passing a collection of objects representing multiple objects.

.LINK
    https://geekwolf.cloud/something
#>

Function Update-GWADObject {
    [CmdletBinding(
        DefaultParameterSetName = 'ByParameters',
        SupportsShouldProcess,
        ConfirmImpact = 'High')
    ]
    param (
        # Parameter set for passing individual parameters
        [Parameter(ParameterSetName = 'ByParameters', Mandatory = $true)]
        [string]$Identity,

        [Parameter(ParameterSetName = 'ByParameters', Mandatory = $false)]
        [string]$UserPrincipalName = $null,    

        [Parameter(ParameterSetName = 'ByParameters', Mandatory = $false)]
        [string]$OrganizationalUnit = $null,

        # Parameter set for passing a collection of objects
        [Parameter(ParameterSetName = 'ByObject', Mandatory = $true, ValueFromPipeline = $true)]
        [PSObject[]]$InputObject,

        [Parameter(ParameterSetName = 'ByObject', Mandatory = $false)]
        [Parameter(ParameterSetName = 'ByParameters', Mandatory = $false)]
        [switch]$Force
    )

    process {
        if ($Force -and -not $Confirm){
            $ConfirmPreference = 'None'
        }

        if ($PSCmdlet.ParameterSetName -eq 'ByParameters') {
            $ObjectsToProcess = @( @{
                Identity=$Identity;
                UserPrincipalName=$UserPrincipalName;
                OrganizationalUnit=$OrganizationalUnit
            } )
        } elseif ($PSCmdlet.ParameterSetName -eq 'ByObject') {
            $ObjectsToProcess = $InputObject
        }

        foreach( $ObjectToProcess in $ObjectsToProcess ) {
            if( [string]::IsNullOrEmpty($ObjectToProcess.Identity) ) {
                $ObjectsFound = @(Get-ADObject -LDAPFilter `
                    "(&(|(objectClass=group)(objectClass=user)(objectClass=computer))(anr=$($ObjectToProcess.Identity)))")
            } else {
                $ObjectsFound = @(Get-ADObject -LDAPFilter `
                    "(&(|(objectClass=group)(objectClass=user)(objectClass=computer))(|(userprincipalname=$($ObjectToProcess.Identity))(anr=$($ObjectToProcess.Identity))))")
            }

            if( $ObjectsFound.Count -gt 1 ) {
                # do we have exact match on UPN
                $Object = @($ObjectsFound | Where-Object { $_.userPrincipalName -eq $ObjectToProcess.Identity })

                # if not, do we have exact match on samAccountName
                if( $Object.count -ne 1 ) {
                    $Object = @($ObjectsFound | Where-Object { $_.SamAccountName -eq $ObjectToProcess.Identity })
                }

                # if not, do we have exact match on Name
                if( $Object.count -ne 1 ) {
                    $Object = @($ObjectsFound | Where-Object { $_.Name -eq $ObjectToProcess.Identity })
                }

                if( $Object.Count -eq 1 ) {
                    $ObjectsFound = $Object
                }
            }

            $ResultMessage = ""
            $Succeeded = $True
            Switch( $ObjectsFound.count ) {
                0 { 
                    Write-Verbose "No object found for [$($ObjectToProcess.Identity)]"
                    $ResultMessage += "[No such object found]"
                    $Succeeded = $False
                   }
                1 {
                    # Validate the OU if it was provided
                    if( [string]::IsNullOrEmpty( $ObjectToProcess.OrganizationalUnit ) -eq $false ) {
                        try {
                            $ADOrganizationalUnit = @(Get-ADObject -Identity $ObjectToProcess.OrganizationalUnit -ErrorAction SilentlyContinue)
                        } catch {
                            $ADOrganizationalUnit = @()
                        }

                        if( $ADOrganizationalUnit.count -eq 0 ) {
                            Write-Verbose "Unable to move [$($ObjectToProcess.Identity)] to [$($ObjectToProcess.OrganizationalUnit)] as OU does not exist" 
                            $ResultMessage += "[Object Move Failed OU does not exist]"
                            $Succeeded = $False
                        }
                    }

                    if( $PSCmdLet.ShouldProcess($ObjectToProcess.Identity) ){
                        # Update the UPN if it was provided
                        if( [string]::IsNullOrEmpty( $ObjectToProcess.UserPrincipalName ) -eq $false ) {
                            try {
                                Set-ADObject -Identity $ObjectsFound[0].ObjectGUID -Replace @{userPrincipalName=$($ObjectToProcess.UserPrincipalName)} | Out-Null
                                $ResultMessage += "[Object Updated Successfully]"
                            } catch {
                                Write-Verbose "Unable to rename [$($ObjectToProcess.Identity)] to [$($ObjectToProcess.UserPrincipalName)] exception: $($_.Exception)" 
                                $ResultMessage += "[Object Update Failed ($($_.Exception))]"
                                $Succeeded = $False
                            }
                        }

                        # Update the OU if it was provided
                        if( [string]::IsNullOrEmpty( $ObjectToProcess.OrganizationalUnit ) -eq $false ) {
                            if( $ADOrganizationalUnit.count -eq 1 ) {
                                try {
                                    Move-ADObject -Identity $ObjectsFound[0].ObjectGUID -TargetPath $ObjectToProcess.OrganizationalUnit | Out-Null
                                    $ResultMessage += "[Object Moved Successfully]"
                                } catch {
                                    Write-Verbose "Unable to move [$($ObjectToProcess.Identity)] to [$($ObjectToProcess.OrganizationalUnit)] exception: $($_.Exception)" 
                                    $ResultMessage += "[Object Move Failed ($($_.Exception))]"
                                    $Succeeded = $False
                                }
                            }
                        }

                     }
                   }
                default { 
                    Write-Verbose "Multiple objects found for [$($ObjectToProcess.Identity)]" 
                    $ResultMessage += "[Multiple objects found]"
                    $Succeeded = $False
                   }
            }

            New-Object PSObject -Property @{
                Identity = $ObjectToProcess.Identity;
                UserPrincipalName = $ObjectToProcess.UserPrincipalName;
                OrganizationalUnit = $ObjectToProcess.OrganizationalUnit;
                Succeeded = $Succeeded;
                ResultMessage = $ResultMessage -replace "`r`n", "\r\n"
            }
        }
    }
}


