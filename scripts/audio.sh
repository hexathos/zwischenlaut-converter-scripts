#!/bin/bash

sourcedir=$HOME/raw_episodes
targetdir=$HOME/episodes
logfile=$sourcedir/logfile.log

function dolog {
	logtext="$(date) $(hostname) ${1}"
	echo "${logtext}" >>${logfile}
	echo ${logtext}
}

##
# get files from raw_eisodes
## 

#
# create blocklist file if it doesn't exist
#

if [ ! -f ${sourcedir}/blocklist ] ; then
	touch ${sourcedir}/blocklist
fi

for file in $(find ${sourcedir}/ -iname "*.wav" -type f) ; do

	cleanname=$(echo ${file}|sed -s "s|${sourcedir}/||g")
	filename=$(echo $cleanname|cut -d "." -f1);

	#
	# check if file was already parsed
	#
	if [ $(grep -c ${cleanname} ${sourcedir}/blocklist) -eq 0 ] ; then
		
	 	dolog "Converting ${file} to mp3 ${filename}.mp3"
		ffmpeg -y -i ${file} -ar 44100 -ac 2 -b:a 192k -q:a 0 -map a ${targetdir}/${filename}.mp3

		dolog "Converting ${file} to m4a ${filename}.m4a"
		ffmpeg -y -i ${file} -ar 44100 -ac 2 -b:a 192k -q:a 0 -map a ${targetdir}/${filename}.m4a

                dolog "Converting ${file} to ogg ${filename}.oga"
                ffmpeg -y -i ${file} -ar 44100 -ac 2 -b:a 192k -q:a 0 -map a ${targetdir}/${filename}.oga

                dolog "Converting ${file} to opus ${filename}.opus"
                ffmpeg -y -i ${file}  -ac 2 -b:a 192k -q:a 0 -map a ${targetdir}/${filename}.opus

                dolog "Converting ${file} to flac ${filename}.flac"
                ffmpeg -y -i ${file} -ar 44100 -ac 2 -b:a 192k -q:a 0 -map a ${targetdir}/${filename}.flac

                dolog "Converting ${file} to au ${filename}.au"
                ffmpeg -y -i ${file} -ar 44100 -ac 2 -b:a 192k -q:a 0 -map a ${targetdir}/${filename}.au

                dolog "Converting ${file} to aac ${filename}.aac"
                ffmpeg -y -i ${file} -ar 44100 -ac 2 -b:a 192k -q:a 0 -map a ${targetdir}/${filename}.aac

                dolog "Converting ${file} to aiff ${filename}.aiff"
                ffmpeg -y -i ${file} -ar 44100 -ac 2 -b:a 192k -q:a 0 -map a ${targetdir}/${filename}.aiff		

		dolog "Copy source file to episode dir"
		cp ${file} ${targetdir}/

		#
		# add file to blocklist
		#

		echo ${cleanname} >> $sourcedir/blocklist
	fi

done
dolog "Finished"
