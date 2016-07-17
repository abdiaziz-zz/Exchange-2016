#Use Windows Task Scheduler to run this powershell script. I have it set for every 10 minutes.

Import-Module ActiveDirectory


Get-ADUser -Filter {UserPrincipalName -like "*@internal.domain.com"} -SearchBase "OU=IAMUsers,OU=Accounts,DC=ad,DC=abdiaziz,DC=com" |
ForEach-Object {
    $UPN = $_.UserPrincipalName.Replace("internal.domain.com","domain.com")
    Set-ADUser $_ -UserPrincipalName $UPN
}
