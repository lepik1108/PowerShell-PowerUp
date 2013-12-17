param([string]$Version,[string]$Path,[switch]$Force)

$Url = "http://ola.hallengren.com/scripts/MaintenanceSolution.sql",
"http://ola.hallengren.com/scripts/DatabaseBackup.sql",
"http://ola.hallengren.com/scripts/DatabaseIntegrityCheck.sql",
"http://ola.hallengren.com/scripts/IndexOptimize.sql",
"http://ola.hallengren.com/scripts/CommandExecute.sql",
"http://ola.hallengren.com/scripts/CommandLog.sql"

if($Force){
}

$Url | %{

    $WebClient = New-Object System.Net.WebClient
    $FileName = (Split-Path ([uri]$_).LocalPath -Leaf)
    $WebClient.DownloadFile($_, $(Join-Path $Path $FileName))
}