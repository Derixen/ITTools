import-module ActiveDirectory 
 
#Set the domain to search at the Server parameter. Run powershell as a user with privilieges in that domain to pass different credentials to the command. 
#Searchbase is the OU you want to search. By default the command will also search all subOU's. To change this behaviour, change the searchscope parameter. Possible values: Base, onelevel, subtree 
#Ignore the filter and properties parameters 
 
$ADComputerParams=@{ 
'Server' = 'DOMAIN.COM' 
'Searchbase' = 'OU=EXAMPLE,DC=DOMAIN,DC=COM'
'Searchscope'= 'Subtree' 
'Filter' = 'name -like "COMPUTERNAME"' 
'Properties' = '*' 
} 
 
get-adcomputer @ADComputerParams | select-object 'name',@{L='iphostnumber'; E={$_.iphostnumber[0]}},@{L='iphostnumber'; E={$_.iphostnumber[1]}}, 'operatingSystem', 'managedby', @{n='lastLogonTimestamp';e={[DateTime]::FromFileTime($_.lastLogonTimestamp)}}  | export-csv -delimiter ";" ".\computers.csv"