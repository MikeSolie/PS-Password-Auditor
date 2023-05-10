# Powershell Password Age Auditor

This PowerShell script retrieves information about user accounts whose passwords have not been changed in the last 90 days. It creates a new`DirectorySearcher` object to search for user accounts, filters the search results to only include accounts with password last set dates older than 90 days then ouputs the SamAccountName, pwdlastset, and enabled status of each matching account. 

## Installation

1. Download the `PasswordAudit.ps1` or `PasswdAudit_PastPresent_Users.ps1` script from this repository
2. Run PowerShell as Administrator and navigate to the folder where the script is saved
3. Run the script by entering `.\PasswordAudit.ps1`

## Usage

To run the script, simply execute the script file in PowerShell using the instructions provided in the Installation section. It will output a table of user account information for all accounts whose passwords have not been changed in the last 90 days.  

## Contributing
If you'd like to contribute to this project, please feel free to fork this repository and submit a pull request with your changes. Be sure to include a description of your changes and any necessary documentation updates.

## License
This project is licensed under the terms of the MIT License. See the LICENSE file for details.
