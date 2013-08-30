<#
$Metadata = @{
  Title = "Move-SPWeb"
	Filename = "Move-SPWeb.ps1"
	Description = ""
	Tags = "powershell, function, sharepoint, move, website"
	Project = ""
	Author = "Janik von Rotz"
	AuthorContact = "http://janikvonrotz.ch"
	CreateDate = "2013-08-07"
	LastEditDate = "2013-08-07"
	Version = "1.0.0"
	License = @'
This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Switzerland License.
To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/ch/ or 
send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.
'@
}
#>

function Move-SPWeb {

<#
.SYNOPSIS
    Move a SharePoint Website.

.DESCRIPTION
	Move a SharePoint Website.

.PARAMETER  Url
	Url of the website to move.

.PARAMETER  Path
	Provide a path for the temporary backup file. optional, default is c:\temp.

.PARAMETER  TargetUrl
	Url of an existing website to overwrite or a new one to create.

.EXAMPLE
	PS C:\> Move-SPWeb -Url "http://sharepoint.domain.ch/Projekte/Buchhaltung/SitePages/Homepage.aspx" -TargetUrl "http://sharepoint.domain.ch/Projekte/Finanzen" -Path 'D:\Export'

#>

	param(
		[Parameter(Mandatory=$true)]
		[String]
		$Url,

		[Parameter(Mandatory=$false)]
		[String]
		$Path = "C:\temp",
        
        [Parameter(Mandatory=$true)]
		[String]
		$TargetUrl
	)
    
    #--------------------------------------------------#
	# modules
	#--------------------------------------------------#	
	if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) 
	{
		Add-PSSnapin "Microsoft.SharePoint.PowerShell"
	}
	
	#--------------------------------------------------#
	# main
	#--------------------------------------------------#
    
    # export spwebsite
    $BackupData = Export-JrSPWeb -Url $(Get-CleanSPUrl -Url $Url) -Path $Path -AddTimeStamp
    
    # import spwebsite
    Import-JrSPWeb -Url $(Get-CleanSPUrl -Url $TargetUrl) -Path $BackupData.FilePath -Template $BackupData.Template
}