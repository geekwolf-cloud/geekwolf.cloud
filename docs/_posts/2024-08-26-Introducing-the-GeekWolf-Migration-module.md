---
layout: post
title:  "Introducing the GeekWolf Migration module"
description: The first early release of the GeekWolf migration module.  Intended to plug gaps where tooling doesn't provide a specific feature or where there are gaps between tools
date:   2024-08-26 18:45:25 +0100
category: on-premises
tags: entra-id identity on-premises
comments_id: 23
---
<h1>{{ page.title }}</h1>

We are proud to release our first version of the GeekWolf.Migration PowerShell module!   It is very early days for us on this, and we have lots of ideas to expand on this module with other useful cmdlets to help those of you doing mergers, acquisitions and divestiture related migrations.   If you have an idea for something that we could or should add then please use the comment section below and we will add it to the backlog for incorporation.

NOTE that at this stage it is NOT signed yet, so you will need to be in the RemoteSigned execution policy or Unrestricted.   You can use `Install-Module GeekWolf.Migration' to install the module.

The very first cmdlet is Update-GWADObject.  This will update the User Principal Name and Organizational Unit of an object.  You can do them one object at a time, or pass in a csv file with many objects.  The output is an array of the objects it was given along with a Succeeded column and a ResultMessage column.

e.g. I created a csv file called RenameAndMove.csv with the following content
```
Identity,UserPrincipalName,OrganizationalUnit
TwanTest@pspsource.local,TwanTest1@pspsource.local,"OU=TwanTestNew1,DC=pspsource,DC=local"
Twan Test Group,,"OU=TwanTestNew,DC=pspsource,DC=local"
TwanTestPC1,,"OU=TwanTestNew,DC=pspsource,DC=local"
```

I then call the following in PowerShell
```powershell
$Results = import-csv .\RenameAndMove.csv | Update-GWADObject -Force
```

and I get
```powershell

OrganizationalUnit : OU=TwanTestNew,DC=pspsource,DC=local
ResultMessage      : [Object Updated Successfully][Object Moved Successfully]
Succeeded          : True
UserPrincipalName  : TwanTest1@pspsource.local
Identity           : TwanTest@pspsource.local

OrganizationalUnit : OU=TwanTestNew,DC=pspsource,DC=local
ResultMessage      : [Object Moved Successfully]
Succeeded          : True
UserPrincipalName  : 
Identity           : Twan Test Group

OrganizationalUnit : OU=TwanTestNew,DC=pspsource,DC=local
ResultMessage      : [Object Moved Successfully]
Succeeded          : True
UserPrincipalName  : 
Identity           : TwanTestPC
```

As I say this is the first cmdlet, more will follow and we'll blog about them here.  Thanks to James Smith from CDW for the idea!


The tool itself is on GitHub, and we are more than happy for others to contribute

Please note that all code is provided on the basis of this [MIT Licence](/licence/)