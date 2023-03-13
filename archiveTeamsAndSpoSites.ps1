# Prerequisite modules.
# Skip if already installed

Install-Module MicrosoftTeams
Install-Module ExchangeOnlineManagement
Install-Module Microsoft.Online.SharePoint.PowerShell

#Retrieve admin credentials and SharePoint admin site URL
$adminCredential = Get-Credential;
$SpoAdminSiteUrl = "https://TenantDomainName-admin.sharepoint.com/"

#Connect to modules using admin credentials
Connect-MicrosoftTeams -Credential $adminCredential
Connect-ExchangeOnline -Credential $adminCredential
Connect-SPOService -url $SpoAdminSiteUrl

# Collecting Teams to be archived
Write-Host "Enter title of team or common title section of teams:"

$teamsTitle = Read-Host;

$teamsToArchive = Get-Team -DisplayName $teamsTitle -Archived $False | select GroupId;

# Archiving Teams and locking respective SharePoint site.
foreach($team in $teamsToArchive) {
    echo "Archiving team: $team.GroupId"
    Set-TeamArchivedState $team.GroupId -Archived $True -SetSpoSiteReadOnlyForMembers $True
    Set-SPOSite -Identity (Get-UnifiedGroup -Identity $team.GroupId).SharePointSiteUrl -LockState ReadOnly
    }
