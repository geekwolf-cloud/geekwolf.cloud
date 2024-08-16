---
layout: default
title:  "Remove BitTitan Migrated Mailbox Items"
date:   2024-01-19 11:45:59 +0100
category: microsoft-365
tags: powershell microsoft-365 migration
---

Migrating mailbox data with BitTitan's MigrationWiz is something that I have done many times, and I'm sure many others have as well.   It works well, is reliable (as of date of writing this anyway :)), and it pretty fast.  However if the mapping is wrong, it seems to migrate data even faster into the wrong account...   This happens occasionally in a migration project, where the client accidentally maps a source mailbox to an already existing (and different) target mailbox.   MigrationWiz does exactly what it is told, but how can we now get the data out of that target mailbox...

I wrote some PowerShell years ago to use EWS and pull that data out of the mailbox, but with the demise of legacy authentication that all stopped working.  So I spent some time today to convert the script's authentication into the modern era.  In the old version I used to use

```powershell
[String] $dllPath = "C:\Program Files\Microsoft\Exchange\Web Services\2.2\Microsoft.Exchange.WebServices.dll"
[Void] [Reflection.Assembly]::LoadFile($dllPath)

$psCred = Get-Credential
$Credentials = New-Object -TypeName Microsoft.Exchange.WebServices.Data.WebCredentials($psCred)

$Service = New-Object Microsoft.Exchange.WebServices.Data.ExchangeService([Microsoft.Exchange.WebServices.Data.ExchangeVersion]::Exchange2010_SP1)
$Service.Credentials = $Credentials
```

Now with the modern way, since we want to use oAuth we have to have an application in Entra ID.  I used the simplest case which is an app registration with delegated permissions, however application permissions and multi tenant applications should work in a very similar way.   Creating the app registration is well documented in [https://learn.microsoft.com/en-us/exchange/client-developer/exchange-web-services/how-to-authenticate-an-ews-application-by-using-oauth](https://learn.microsoft.com/en-us/exchange/client-developer/exchange-web-services/how-to-authenticate-an-ews-application-by-using-oauth ) although I found I had to add more permissions than the article told me as shown below

![App Registration Delegated Permissions](/assets/images/2024-01-19-Remove-BitTitan-Migrated-Mailbox-Items-1.png)

I then used the application id and tenant id to authenticate to the Microsoft 365 tenant with a user account that had the rights to the mailboxes.


```powershell
Add-Type -Path "C:\Program Files\Microsoft\Exchange\Web Services\2.2\Microsoft.Exchange.WebServices.dll"

Import-Module MSAL.PS

$authResult = Get-MsalToken -ClientId $clientId -TenantId $tenantId -Scopes @("https://outlook.office365.com/EWS.AccessAsUser.All") -Interactive

$Service = New-Object Microsoft.Exchange.WebServices.Data.ExchangeService([Microsoft.Exchange.WebServices.Data.ExchangeVersion]::Exchange2010_SP1)
$Service.Credentials = New-Object Microsoft.Exchange.WebServices.Data.OAuthCredentials($authResult.AccessToken)
```


You can find the entire script here [Remove-BitTitanMigratedMailboxItems.ps1.txt](/assets/downloads/Remove-BitTitanMigratedMailboxItems.ps1.txt)

Please note that all code on the basis of this [MIT Licence](/licence)