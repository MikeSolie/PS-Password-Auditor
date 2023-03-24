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
	Filter = "(&amp;(ObjectClass=user)(ObjectCategory=person)(pwdlastset&lt;=$PwdDate))
	PageSize = 500 # Limit the number of results to 500
}

# Find user accounts that match search criteria
$Searcher.FindAll() | ForEach-Object {
	# New object to store results
	New-Object -TypeName PSCustomObject -Property @{
		SamAccountName = $_.Properties.SamAccountName -join'' # pull and concatenate SamAccount
		pwdlastset = [datetime]::FromFileTime([int64]($_.Properties.pwdlastset -join'')) # pull pwdlastset value and convert to datetime object
		enabled = -not [boolean]([int64]($_.properties.useraccountcontrol -join'') -band 2) # Checks if acct is enabled
	}
}
