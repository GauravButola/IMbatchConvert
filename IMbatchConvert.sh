#!/bin/bash

#Gaurav Butola | GauravButola@gmail.com
#This script for batch conversion of images uses ImageMagick http://www.imagemagick.org/

################ Wish List ##################
# Check if imagemagick is installed		-	Done
# Create new folder for converted images	-	Done

#Configuration
outputSize=1200
outputQuality=70
outputDir="output"

function convertImages 
{
	mkdir -p "$1/$outputDir"
	#for i in path/to/pics/*.jpg
	for i in $1/*.$extension
	do
 	#Get filename from path
	filename=$(basename $i)
	
	convert "$i" -adaptive-resize $outputSize "$1/$outputDir/$filename"
	convert "$1/$outputDir/$filename" -quality $outputQuality "$1/$outputDir/$filename" 
	echo "$i DONE"
	done
}

#Is ImageMagick installed
function isInstalled
{
	if which convert >> /dev/null
	then
		echo 1
	else
		echo 0
	fi
}

function main
{
	#Check if argument is provided
	if [ $# == 0 ]
	then
		#If no argument, run in current directory
		sourceFolder=$PWD
	else
		#Get source folder, if provided
		sourceFolder=$1
	fi

	#Get the image extension
	echo "What is the extension (case sensitive) of your pictures? eg: jpg JPG png PNG"
	read extension

	if [ $(isInstalled) -eq 1 ]
	then
		#Call convert function
		convertImages $sourceFolder
	else
		echo "ImageMagick not found on this system. Do you want to install? y/n"
		read install
		if [ $install = "y" ]
		then
			#Installing imagemagick
			sudo apt-get install -y imagemagick
			clear
			main $1
		else
			echo "Exiting"
			exit
		fi
	fi
}

main $1
