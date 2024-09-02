# The Geekwolf.Migration module, helping you with Microsoft related M&A activity

This module was created to start to collect together scripts and snippets that I have been using over the years, and answering 'wouldn't it be nice if..' questions from others in this space.  I am always happy to take feedback, be that good or bad, but prefer constructive criticism :)    

## Update-GWADObject

This function is to update an Active Directory object's userPrincipalName (UPN) and/or organizational unit (OU).  This is often done during a migration between forests where the target has a different UPN and OU structure.  The function will work for user, group and computer objects.  The output is a collection of objects with a success indicator and a results message.

### Parameters

**Identity**
   The identity of the object.  This can be a UserPrincipalName, a SamAccountName or a Name.  The function will try to find a unique match for that in the current domain,  This parameter is used in the 'ByParameters' parameter set.

**UserPrincipalName**
   The new UserPrincipalName for the object. This parameter is used in the 'ByParameters' parameter set.

**OrganizationalUnit**
   The new Organizational Unit to which the object should be moved. This parameter is used in the 'ByParameters' parameter set.

**InputObject**
   A collection of objects where each object has properties 'Identity', 'UserPrincipalName', and 'OrganizationalUnit'. 
   This parameter is used in the 'ByObject' parameter set and supports pipeline input.

**Force**
   Force updating the object so that it doesn't ask you to confirm each one (alternative to -Confirm:$False)

### Examples

**Example 1:**
```powershell
Update-GWADObject -Identity "user1@domain.com" -UserPrincipalName "user1.new@domain.com" -OrganizationalUnit "OU=NewOU,DC=domain,DC=com"
```
        
Description: This example updates a single object's User Principal Name and moves the object to a new Organizational Unit.

**Example 2:**
```powershell
    $objects = @(
        [PSCustomObject]@{Identity = "user2@domain.com"; UserPrincipalName = "user2.new@domain.com"; OrganizationalUnit = "OU=NewOU,DC=domain,DC=com"},
        [PSCustomObject]@{Identity = "Group Name"; UserPrincipalName = $null; OrganizationalUnit = "OU=NewOU,DC=domain,DC=com"}
    )
    $objects | Update-GWADObject
```

Description: This example takes a collection of objects from a pipeline and updates their User Principal Name and/or Organizational Unit

**Example 3:**
```powershell
Import-Csv -Path c:\renames.csv | Update-GWADObject | Export-Csv c:\rename-results.csv -NoTypeInformation -Encoding UTF8

```

Description: This example takes a collection of objects from a CSV, updates their User Principal Name and/or Organizational Unit, and outputs a CSV with the results
