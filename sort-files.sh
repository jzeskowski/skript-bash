#!/bin/sh
targetfolder="/path/to/destination"
sourcefolder=$(pwd)
EXTENSION="JPG"
for f in *.$EXTENSION; do
	if [[ "$f" != "" ]]; then
		COPY_FILE_OK="0"
		echo "Check File $f"
		CREATION_DATE=$(identify -format %[EXIF:DateTime] $f | awk '{ print $1 }' | sed s/:/-/g)
		YEAR_FOLDER=$(date --date="$CREATION_DATE" "+%Y")
		echo "Year: $YEAR_FOLDER"
		SUBFOLDER=$(date --date="$CREATION_DATE" "+%d.%m.")
		SUBFOLDER="$SUBFOLDER - Unbekannt"
		echo "Date: $SUBFOLDER"
		SORTED_FOLDER="$targetfolder/$YEAR_FOLDER/$SUBFOLDER/"
		echo "move to: $SORTED_FOLDER"
		FILE_EXISTS=$(find $targetfolder -not -path "$sourcefolder*" -not -empty -type f -iname "*.$EXTENSION" -size $(stat -c"%s" $f)c -print0)
		if [[ "$FILE_EXISTS" != "" ]]
		then
			diff -q "$FILE_EXISTS" "$f"
			if [ "$?" -eq 0 ]
			then
				echo "Exact Duplicate Found"
			else 
				echo "Files Differ"
				COPY_FILE_OK="1"
			fi
			
		else 
			echo "No Duplicate Found"
			COPY_FILE_OK="1"
		fi
		# einsortieren ist gestatttet, kein duplikat
		# wir sortieren ein
		if [[ "$COPY_FILE_OK" != "0" ]]
		then
			echo "Copy File"
			mkdir -p "$SORTED_FOLDER"
			mv -n "$f" "$SORTED_FOLDER$f"
		fi
	fi
done
