#batch create AD users for prototyping
#author: stephan.steiger@ioz.ch
#date: 26.5.2010

$prefix = "pt09"
$ouName = "Prototype09"


#do not modify lines below #

$adsi = [ADSI]"LDAP://DC=iozdctest,DC=ch"
 Write-Host "Creating OU $ouName... " -NoNewline
$ou = $adsi.create("organizationalUnit","OU=$ouName,OU=Playground")
$ou.setInfo()
Write-Host "done" -ForegroundColor yellow

Write-Host "Creating OU Admins... " -NoNewline
$admins = $ou.create("organizationalUnit","OU=Admins")
$admins.setInfo()
Write-Host "done" -ForegroundColor yellow
Write-Host "Creating OU Users... " -NoNewline
$users = $ou.create("organizationalUnit","OU=Users")
$users.setInfo()
Write-Host "done" -ForegroundColor yellow

$allAccounts =  @("spadmin","spfarm","spintranet","spsearchadmin","spsearch","spservices","spmysite","spcthub")

$allAccounts | foreach {
    $accountName = "$prefix-$_"
    Write-Host "Creating account $accountName... " -NoNewline
    $account = $admins.create("user","CN=$accountName")
    $account.Put("sAMAccountName",$accountName)
    $account.Put("sn",$accountName)
    $account.Put("DisplayName",$accountName)
    $account.setInfo()
    $currentUAC = [int]($account.userAccountCOntrol.ToString())
    $newUAC =  $currentUAC -bor 65536
    $account.Put("userAccountControl",$newUAC)
    $account.setInfo()
    $account.psbase.Invoke(“SetPassword”,”sgs2aIOZ”)
    $account.psbase.InvokeSet(‘Accountdisabled’,$false)
    $account.psbase.CommitChanges()
    Write-Host "done" -ForegroundColor yellow
}
Write-Host "Please manually change password for $prefix-spadmin and save it to KeePass" -ForegroundColor red
Write-Host "finished" -ForegroundColor yellow
