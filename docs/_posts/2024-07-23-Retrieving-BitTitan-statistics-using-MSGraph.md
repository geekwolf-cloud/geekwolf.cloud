---
layout: post
title:  "Retrieving BitTitan statistics using Microsoft Graph"
date:   2024-07-23 14:22:34 +0100
category: microsoft-365
tags: powershell microsoft-365 migration
comments_id: 15
---
<h1>{{ page.title }}</h1>

When you are using BitTitan MigrationWiz you can ask it to email you project statistics.  Now this is great when you only have a handful of projects, but when you migrate tens of thousands of mailboxes, archives, OneDrive sites at the same time (and with BitTitan's guidance to not have more than about 700 entries per project) you end up with a lot of projects.   You do get the statistics in your mailbox but creating a single file with all the stats is non trivial.   So to combat that I wrote some PowerShell...  The first approach was to look at using VBA in Outlook, however the new Outlook client no longer supports VBA.  So I turned to Microsoft Graph to read my mailbox, and it was surprisingly effective.  

Let's walk through the code, it is available as a download [Extract-BTMigWizStats.ps1.txt](/assets/downloads/Extract-BTMigWizStats.ps1.txt):

```powershell
param(
	[string]$TargetFolderPath = '~\Downloads\BTStatistics',
	[datetime]$StartDateTime = (Get-Date).AddDays(-1),
	[datetime]$EndDateTime = (Get-Date),
	[string]$MailboxFolder = 'Inbox'
)
```

We're taking a few parameters as input with the StartDateTime being yesterday, EndDateTime is right now, and the mailbox folder and target folder defaulting to something sensible

```powershell
if( $Null -eq (Get-MGContext) ) {
	Connect-MGGraph
}
```

Let's connect to Microsoft Graph, but only if we're not already connected
 
```powershell
function Get-MGGraphAllResults {
param( $Uri )
	$Values = @()
	do{
		$Results = Invoke-MgGraphRequest -Uri $Uri
		$Values += $Results.Value
		$Uri = $Results."@odata.nextLink"
	} while( $Uri )
	write-output $Values
}
```

A function to get all the pages returned by MS Graph

```powershell
$MailFolders = Get-MGGraphAllResults -Uri https://graph.microsoft.com/v1.0/me/mailFolders/delta
$MailboxFolderParts = $MailboxFolder.Split('\')
$FoundFolder = $MailFolders | ? { $_.DisplayName -eq $MailboxFolderParts[0] }
for( $i = 1; $i -lt $MailboxFolderParts.Count; $i++ ) {
	$FoundFolder = $MailFolders | ? { $_.DisplayName -eq $MailboxFolderParts[$i] -and $_.ParentFolderId -eq $FoundFolder.Id }
}
```

Here we get all the mailbox folders and then find the one that was passed in as a parameter.  Subfolders separated by \ are traversed to locate the lower level folder

```powershell
if( $FoundFolder ) {
	$Messages = Get-MGGraphAllResults -Uri "https://graph.microsoft.com/v1.0/me/mailFolders/$($FoundFolder.Id)/messages?`$filter=(contains(subject, 'Migration Statistics for Project ')) and (createdDateTime ge $($StartDateTime.ToString("yyyy-MM-ddTHH:mm:ssZ"))) and (createdDateTime le $($EndDateTime.ToString("yyyy-MM-ddTHH:mm:ssZ")))"
```

We are now getting the emails with the correct Subject, and with the creation date between our StartDateTime and EndDateTime parameters 


```powershell
	if( -not (Test-Path $TargetFolderPath -Type Container) ) { New-Item $TargetFolderPath -Type Container | Out-Null}
	$TargetFolder = Get-Item $TargetFolderPath
```

Let's make sure the target folder exists, or we create it

```powershell
	if( $TargetFolder.Attributes -contains 'Directory' ) {
		Foreach( $Message in $Messages ) {
			$ProjectName = $Message.Subject -replace 'Migration Statistics for Project ', ''
			$FileDate = $Message.createdDateTime.ToString( 'yyyyMMdd-HHmmss' )

			$Attachments =  Get-MGGraphAllResults -Uri "https://graph.microsoft.com/v1.0/me/messages/$($Message.Id)/attachments"
```

Looping through each email and grabbing the attachments

```powershell
			Foreach( $Attachment in $Attachments ){
				if( $Attachment.Name -eq 'ProjectStats.zip' ) {
					$FilePath = $TargetFolder.FullName + '\' + $ProjectName + '-' + $FileDate

					# Ensure the folder exists
					if( -not (Test-Path $FilePath -Type Container) ) { New-Item $FilePath -Type Container }
```

Looping through each attachment, ensuring the folder for this email exists so we can extract the attachment

```powershell
					# create and expand the zip file
					[IO.File]::WriteAllBytes( ($FilePath + '.zip'), ([Convert]::FromBase64String($Attachment.contentBytes))) | Out-Null
					Expand-Archive ($FilePath + '.zip') -DestinationPath $FilePath -Force | Out-Null

					# Rename the extracted CSV file
					$ExtractedCsvFile = Join-Path -Path $TargetFolder.FullName -ChildPath 'ProjectStats.csv'
					if (Test-Path $ExtractedCsvFile) {
						Rename-Item -Path $ExtractedCsvFile -NewName ($FilePath + '.csv')
					}
```

Downloading the attached zip file, extracting the desired csv file, and renaming that so it is different for each email

```powershell
					Remove-item $FilePath -Force -Recurse
					Remove-item ($FilePath + '.zip') -Force
				}
			}
		}
	} else {
		Write-Host "Folder $TargetFolderPath is not a valid folder" -fore red
	}
```

Some tidying up, and throwing an error if the target folder isn't valid


```powershell
	# Merge the csv files and then export to Excel
	$Files = Get-ChildItem $TargetFolder -Recurse | Where-Object { $_.Name -like "*.csv"}
	$ItemResultHeaders = @()
	$ItemResultExports = @()
 
	foreach ( $File in $Files  ) {
```

We get all the csv files we extracted and loop through each one

```powershell
		if( $File.VersionInfo.FileName -like "*.csv" ) {
			$ItemResults = @(Import-CSV $File.VersionInfo.FileName | select @{name="SourceFile";Expression={$File.Name}},*)
			$CsvHeader = Get-Content -Path $File.VersionInfo.FileName -TotalCount 1
			# try to find the previous set of header columns
			$ItemResultExportIndex = -1
			for( $i = 0; $i -lt $ItemResultHeaders.count; $i++ ) {
				if( $ItemResultHeaders[$i] -eq $CsvHeader ) {
					$ItemResultExportIndex = $i
				}
			}
```

We check to see if the csv header had been seen before, as that indicates it is the same project type

```powershell
			# if the header is new then add a new exports array element
			if( $ItemResultExportIndex -eq -1 ) {
				$ItemResultsExportIndex = $ItemResultHeaders.Count
				$ItemResultHeaders += @($CsvHeader)
				$ItemResultExports += ''
				$ItemResultExports[$ItemResultsExportIndex] = $ItemResults
			} else {
				$ItemResultExports[$ItemResultsExportIndex] += $ItemResults
			}
		}
	}
```

We consolidate the csv files into a file per project type (using the csv header to distinguish the different project types)

```powershell

	for( $i = 0; $i -lt $ItemResultHeaders.count; $i++ ) {
		$ItemResultExports[$i] | Export-Excel "$($TargetFolder.FullName)-MigWizStats.xlsx" -WorksheetName "MigWizStats-$($i)" -Append -AutoSize -FreezeTopRow -BoldTopRow
	}
} else {
	write-Host "Folder $MailboxFolder cannot be found" -fore Red
}
```

Finally, we export each consolidated csv as a sheet in a single Excel workbook.

So there you have it, this has been a great time saver.  This example also shows how you can use MS Graph to go through your mailbox to retrieve mail.

Please note that all code is provided on the basis of this [MIT Licence](/licence)