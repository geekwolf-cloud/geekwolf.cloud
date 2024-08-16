---
layout: post
title:  "Convert between SID and ObjectId"
date:   2024-01-12 09:31:12 +0100
category: entra-id
tags: entra-id identity
comments_id: 2
---

In Active Directory we are used to seeing Security Identifiers (SIDs) in Access Control Lists (ACLs) and they are made up of S-1-5-12-<domain SID>-<RID> where the RID for non system objects is a number above 1000.  Now in Azure AD that wouldn't work as the RID part would quickly exhaust and there is no concept of a domain SID.   So what Microsoft do instead is that they convert the ObjectId of the user, group, role to a SID.  

You can convert between the two using some small PowerShell functions

**Convert ObjectId to SID**
```powershell
function Convert-ObjectIdToSid
{
    param([String] $ObjectId)
    $d=[UInt32[]]::new(4)
    [Buffer]::BlockCopy([Guid]::Parse($ObjectId).ToByteArray(),0,$d,0,16)
    "S-1-12-1-$d".Replace(' ','-')
}
```

**Convert SID to ObjectID**
```powershell
function Convert-SidToObjectId
{
    param([String] $SID)

    $BaseEventId = 500

    if( $SID -like 'S-1-12-1-*-*-*-*' ) {
        $d=[UInt32[]]::new(4)
        $SIDParts = $SID.Split('-')
        $d[0] = [uint32]$SIDParts[4]
        $d[1] = [uint32]$SIDParts[5]
        $d[2] = [uint32]$SIDParts[6]
        $d[3] = [uint32]$SIDParts[7]
        $guid = [byte[]]::new(16)
        [Buffer]::BlockCopy($d,0,$guid,0,16);
        [guid]$guid
    } else {
        write-Log ($BaseEventId + 1) "Warning: Not an Azure AD Sid [$SID]" "Warning"
    }
}
```


Please note that all code on the basis of this [MIT Licence](/licence)