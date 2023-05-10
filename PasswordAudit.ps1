#########################################
# Mike Solie	        		#
# AD Password Age Audit 		#
# Description:				#
# Audits passwords that haven't been	#
# changed in 90 days 		        #
#########################################

# Date from 90 days ago converted to file time value
$PwdDate = (Get-Date).AddDays(-90).ToFileTime()

# Search user accounts using DirectorySearcher object
$Searcher = New-Object DirectoryServices.DirectorySearcher -Property @{
    Filter = "(&(ObjectClass=user)(ObjectCategory=person)(pwdlastset<=$PwdDate))"
    PageSize = 500 # Limit the number of results to 500
}
# Find user accounts that match search criteria
$Searcher.FindAll() | ForEach-Object {
    $searchResult = $_
    $userAccountControl = [int64]($searchResult.Properties["useraccountcontrol"] -join '')
    # Check if account is enabled (bitwise AND with 2)
    if (-not ($userAccountControl -band 2)) {
        # New object to store results
        New-Object -TypeName PSCustomObject -Property @{
            SamAccountName = $searchResult.Properties["samaccountname"] -join '' # Retrieve SamAccountName property
            pwdlastset = [datetime]::FromFileTime([int64]($searchResult.Properties["pwdlastset"] -join '')) # Retrieve pwdlastset value and convert to datetime object
        }
    }
} | Sort-Object -Property SamAccountName | Format-Table 

# The loop can be piped into Export-Csv instead of sorting the object and formatting it in the terminal
