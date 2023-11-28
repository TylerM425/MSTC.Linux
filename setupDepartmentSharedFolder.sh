#!/bin/bash


groups=('Sales'
'HumanResources'
'TechnicalOperations'
'Helpdesk'
'Research')

base=$1
if [ -z "$base"  ]; then
	echo
	echo "Creates a department shared folder structure at specified location"
	echo "	Usage: $0 <root folder>"
	echo
	exit 1

fi

user=`whoami`
if [ "$user" != "root" ]; then
	echo "You need root"
	exit 1
fi

for group in ${groups[*]}; do
	echo "Processing group: $group..."

	if [ ! $(getent group $group)  ]; then
		echo "Creating groups $group..."
		groupadd $group
	fi

	folder="$base/$group"
	if [ ! -d "$folder" ]; then
	echo "Creating shared folder at $folder..."
	mkdir -p  "$folder"
	fi

	echo " - Applying $user:$group ownership on $folder..."
	chown "$user:$group" "$folder"

	echo " - Applying permissions on $folder... $user=rwx,$group=rwx,o="
	chmod o+rwx,g+rwx,o-rwx "$folder"

	echo " - Granting permissions (rx) to Helpdesk on $folder..."
	setfacl --modify=g:Helpdesk:rx "$folder"


done


