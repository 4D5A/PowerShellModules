function Get-LocalAdmins
{
    <#
        .Synopsis
            Enumerate local administrative accounts.
        
        .Description
            Enumerate local administrative accounts. Depending on which switches are passed to the script, the enumeration may be enabled local admin accounts (-e), disabled local admin accounts (-d), enabled and disabled admin accounts (-f), or a the usernames of active admin accounts only (-m).

        .Example
            Get-LocalAdmins -d
        
        .Example
            Get-LocalAdmins -e
        
        .Example
            Get-LocalAdmins -f
            
        .Example
            Get-LocalAdmins -m
    #>

    param(
        # Use switch m to only display the name for each active administrator account
        [switch]$d,
        [switch]$e,
        [switch]$f,
        [switch]$m
    )
    $computer = $Env:COMPUTERNAME
	
	$workgroup = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -Property Domain | Format-Table -HideTableHeaders
        
	$q="Associators of {Win32_Group.Domain='$computer',Name='Administrators'} where Role=GroupComponent"
        
	If ($d) {
		Get-WmiObject -Query $q -Computer $Computer | Where{$_.Disabled -eq $True} |
        
			Select @{Name="Members";Expression={$_.Caption}},
			@{Name="Object Type";Expression={([regex]"User|Group").matches($_.__CLASS)[0].Value}},
			@{Name="Computername";Expression={$_.__SERVER}}
	}
        
	If ($e) {
		Get-WmiObject -Query $q -Computer $Computer | Where{$_.Disabled -eq $False} |
        
			Select @{Name="Members";Expression={$_.Caption}},
			@{Name="Object Type";Expression={([regex]"User|Group").matches($_.__CLASS)[0].Value}},
			@{Name="Computername";Expression={$_.__SERVER}}
	}
        
	If ($f) {
		$Status = $False
		Get-WmiObject -Query $q -Computer $Computer |
        
			Select @{Name="Members";Expression={$_.Caption}},
			@{Name="Object Type";Expression={([regex]"User|Group").matches($_.__CLASS)[0].Value}},
			@{Name="Disabled";Expression={$_.Disabled}},
			@{Name="Computername";Expression={$_.__SERVER}}
			}           
                
	 If ($m) {
        
			Get-WmiObject -Query $q -Computer $Computer | Where{$_.Disabled -eq $False} |
        
				Select @{Name="Members";Expression={$_.Name}} | Select-Object -Property Members | Format-Table -HideTableHeaders
				}                 
                
}