# Incident Response and System information collection script

# Insert ticket number
function TKT {

    $TKTNUM = read-host -p "What is the ticket number for this report? (e.g. 0001) "

    $CHKTKT = read-host -p "You entered $TKTNUM.  Is that correct? (y/n)?"

    # Check to be sure the ticket number is correct.
    if ($CHKTKT -match "[nN]") {

        TKT

    } elseif ( $CHKTKT -match "[yY]") {

    } else {
    
        $TKTNUM = Get-Random -Maximum 1000
        
    }

    # Make the $TKTNUM value globally available in the script with $script:
    $script:TKTNUM = $TKTNUM
}

# Insert user name
function USR {

    $USRNAME = read-host -p "Enter the userID authenticated at the time of the incident (e.g. bmookie)"
    $CHKUSR = read-host -p "You entered $USRNAME.  Is that correct? (y/n)?"

    # check to be sure username is correct.
    if (!$CHKUSR) {

       $USRNAME = $env:USERNAME

    
    } elseif ($CHKUSR -match "[nN]") {

        USR
    
    } elseif ( $CHKUSR -match "[yY]") {

    } else {
    
      write-host -BackgroundColor red -ForegroundColor white "Invalid value"
       sleep 2
       USR
        
    }
        # Make the $USRNAME value globally available in the script with $script:
        $script:USRNAME = $USRNAME
}

# Clear the screen
clear

# Call the functions to collect ticket number and username
TKT 
USR


# Get COMPUTERNAME
$t_computer = $env:COMPUTERNAME

# Get Current User Profile
$t_user = $env:USERPROFILE + "\Desktop"

# Set results save location
$results = "$t_user\$TKTNUM-$t_computer-Results"

# If the directory exist the program will exit
# Here is a test to see if it exists and to continue or to make it.
$dirExists = Test-Path -Path "$results"

if ($dirExists -eq $True) {

    write-host -BackgroundColor green -ForegroundColor white "$results exists"

} else { 

    # Create location to save results
    mkdir "$results"

    
}


# Perform security checks
Write-host  -BackgroundColor red -ForegroundColor white "Collecting Running Processes"
Get-Process | select ProcessName, ID, Path | export-csv -Path $results\processes.csv

Write-host  -BackgroundColor red -ForegroundColor white "Collecting Running Services"
Get-WMIObject -Class Win32_Service | select Name, PathName | export-csv -Path $results\services.csv

Write-host  -BackgroundColor red -ForegroundColor white "Collecting Users"
Get-WmiObject -Class Win32_Account | export-csv -Path $results\windowsAccounts.csv

Write-host  -BackgroundColor red -ForegroundColor white "Collecting Groups"
Get-WmiObject -Class Win32_Group | export-csv -Path $results\windowsGroups.csv

Write-host  -BackgroundColor red -ForegroundColor white "Collecting Password Policies"
net accounts | Tee-Object -FilePath $results\netAccounts.txt

Write-host  -BackgroundColor red -ForegroundColor white "Collecting Network Ports"
netstat -an | Tee-Object -FilePath $results\netstat.txt

Write-host  -BackgroundColor red -ForegroundColor white "Collecting network Statistics"
netstat -s | Tee-Object -FilePath $results\netstatStats.txt

Write-host  -BackgroundColor red -ForegroundColor white "Collecting Directory Structure"
tree C:\ /F | Tee-Object -FilePath $results\directory.txt

Write-host  -BackgroundColor red -ForegroundColor white "Collecting System Info"
systeminfo > $results\sysinfo.txt