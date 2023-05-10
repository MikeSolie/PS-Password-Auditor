#########################################
# Mike Solie	        		#
# AD Password Age Audit 		#
# Description:				#
# Audits passwords that haven't been	#
# changed in 90 days and includes 	#
# inactive users			#
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
    # New object to store results
    New-Object -TypeName PSCustomObject -Property @{
        SamAccountName = $searchResult.Properties["samaccountname"] -join '' # Retrieve SamAccountName property
        pwdlastset = [datetime]::FromFileTime([int64]($searchResult.Properties["pwdlastset"] -join '')) # Retrieve pwdlastset value and convert to datetime object
        enabled = -not [boolean]([int64]($searchResult.Properties["useraccountcontrol"] -join '') -band 2) # Checks if acct is enabled
    }
} | Sort-Object -Property pwdlastset | Format-Table

# Can be piped into Export-Csv instead of sorting and formatting into a table in the terminal
