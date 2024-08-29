# GeekWolf.Migration.psm1

# Import Private Functions
if( Test-Path $PSScriptRoot\Private ) {
	Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 | ForEach-Object { . $_.FullName }
}

# Import Public Functions
if( Test-Path $PSScriptRoot\Public ) {
	Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 | ForEach-Object { . $_.FullName }
}
