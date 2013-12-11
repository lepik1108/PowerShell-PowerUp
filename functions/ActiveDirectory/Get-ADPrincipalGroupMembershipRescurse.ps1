<#
$Metadata = @{
	Title = "Get Active Directory Principal Group Membership Recurse"
	Filename = "Get-ADPrincipalGroupMembershipRecurse.ps1"
	Description = ""
	Tags = "powershell, activedirectory, get, prinicipal, group, membership, recurse"
	Project = ""
	Author = "Janik von Rotz"
	AuthorContact = "http://janikvonrotz.ch"
	CreateDate = "2013-12-11"
	LastEditDate = "2013-12-11"
	Url = ""
	Version = "1.0.0"
	License = @'
This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Switzerland License.
To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/ch/ or 
send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.
'@
}
#>

function Get-ADPrincipalGroupMembershipRecurse{

<#
.SYNOPSIS
    Get Active Directory principal group membership recursively.

.DESCRIPTION
	Get Active Directory principal group membership recursively.

.PARAMETER  ADUser
	Active Directory user to report.

.PARAMETER  ADGroup
	Looping parameter not required!

.PARAMETER  ADGroup
    Looping parameter not required!

.EXAMPLE
	PS C:\> Get-ADPrincipalGroupMembershipRecurse -ADUser (Get-ADUser user1) | Out-GridView
#>

	[CmdletBinding()]
	param(
        
		[Parameter(Mandatory=$false)]
		[ValidateNotNullOrEmpty()]
		$ADUser,

		[Parameter(Mandatory=$false)]
		[ValidateNotNullOrEmpty()]
		$ADGroup,
        
        [Parameter(Mandatory=$false)]
        $Level = 0
    )
        
    #--------------------------------------------------#
    # modules
    #--------------------------------------------------#
    Import-Module ActiveDirectory
  
    #--------------------------------------------------#
    # main
    #--------------------------------------------------#
    
    # loop select for user parameter
    if($ADUser){
    
        # get membership groups of user and run this function
        $ADGroups = Get-ADPrincipalGroupMembership $ADUser | %{
            Get-ADPrincipalGroupMembershipRecurse -ADGroup $_ -Level ($Level+1)
        }
        
        # get max number of levels
        $Levels = ($ADGroups | %{$_.Level} | measure -Maximum).Maximum + 1
        
        # display the results in columns
        $ADGroups | %{
            
            # create a column item
            $Item = New-Object –TypeName PSObject
            
            # create a column for each level
            $Index = 1;while($Index -ne $Levels){
                
                # place the value in the right level
                if($_.Level -eq $Index){
                    $Item | Add-Member –MemberType NoteProperty –Name "Level $Index" –Value $_.Name   
                }else{
                    $Item | Add-Member –MemberType NoteProperty –Name "Level $Index" –Value ""
                }
            
                $Index += 1
            }
            
            #output
            $Item
        }
        
    # loop select for group parameter
    }elseif($ADGroup){
    
        # show a progress
        Write-Progress -Activity "Collecting Data" -Status "$($_.Name)" -PercentComplete (Get-Random -Minimum 1 -Maximum 100)
        
        # return the item and its level
        $_ | select Name,@{L="Level";E={$Level}}
        
        # check for further membershipments of this group and loop this function
        Get-ADPrincipalGroupMembership $_ | %{
            Get-ADPrincipalGroupMembershipRecurse -ADGroup $_ -Level ($Level+1)
        }
    }
}