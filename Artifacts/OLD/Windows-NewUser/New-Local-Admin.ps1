$Account="Administrateur2"
$Password="SuperPassword!"

#Crate new account
Net User $Account $Password /add

#Set the user to be Administrator
Net Localgroup Administrators /add $Account
Net Localgroup Users /delete $Account