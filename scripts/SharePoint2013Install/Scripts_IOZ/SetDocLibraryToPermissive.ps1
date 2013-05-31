$snapin = Get-PSSnapin Microsoft.SharePoint.Powershell -ErrorVariable err -ErrorAction SilentlyContinue
if($snapin -eq $null){
Add-PSSnapin Microsoft.SharePoint.Powershell 
}

$site = Get-SPSite http://sharepoint.vbl.ch
foreach ($web in $site.allwebs){
    foreach($list in $web.Lists){
       if(($list.BaseType -ieq "DocumentLibrary") -and  ($list.BrowserFileHandling -ieq "Strict") -and ($list.Hidden -ieq $False) -and ($list.BaseTemplate -ieq "DocumentLibrary") -and ($list.IsSiteAssetsLibrary -ieq $False)){
            Write-Host $web "-->" $list "-->" $list.BrowserFileHandling        
            $list.BrowserFileHandling="Permissive"
            $list.Update()
       }
    }
}
