#Use Windows Task Scheduler to run this powershell script. I have it set for every 10 minutes.

#Run as AD user with batch logon permissions and permission to modify user object in AD:

#Action: C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe

#Script: -NoProfile -Executionpolicy bypass -file "C:\Powershell Scripts\ChangeUPN.ps1"

#BEGIN POWERSHELL SCRIPT

Import-Module ActiveDirectory


Get-ADUser -Filter {UserPrincipalName -like "*@internal.contoso.com"} -SearchBase "OU=IAMUsers,OU=Accounts,DC=ad,DC=contoso,DC=com" |
ForEach-Object {
    $UPN = $_.UserPrincipalName.Replace("internal.contoso.com","contoso.com")
    Set-ADUser $_ -UserPrincipalName $UPN
}
