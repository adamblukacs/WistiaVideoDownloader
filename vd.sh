#!/bin/bash

# checking you give an altehernativ path or you download the video to ./videos folder
if [[ -n $ALTERPATH ]]; then
    FILEPATH=$ALTERPATH"/"
else
    FILEPATH="./videos/"
fi


echo -e "The standard download folder is $FILEPATH \n
If you want to change it, give an absolute path.\n"
echo -n 'Type your videoname: '
read videoNameWithSpace
videoName=${videoNameWithSpace// /\_/g}
#videoName=` echo $videoNameWithSpace | sed -e 's/ /\_/g'`
#echo $videoName

echo -n "Copy and paste the link and thumbnail: "
read videoLink

linkID=$(sed 's/.*video=\(.*\)".*/\1/' <<< "$videoLink")

content=$(curl https://fast.wistia.net/embed/iframe/${linkID}?videoFoam=true 2>&1 | grep -Eo 'https://embed-ssl.wistia.com/deliveries/[^/"]+' | sed -n 2p)

if [[ $videoName =~ ^/ ]]; then 
    echo absolutPath 
    fp=$videoName
    export ALTERPATH="${videoName%/*}"
    FILEPATH=$ALTERPATH
    #echo "$ALTERPATH"
    #set | grep ALTERPATH | sed 's/.*=\(.*\)A.*/\1/'
else 
    echo stenderdPath
    fp=$FILEPATH$videoName
fi

# if the download folder does not exist, create it
if ! [ -f "$FILEPATH" ]; then
    mkdir -p "$FILEPATH"
fi


download_video () {
    wget -O "$fp.mp4" "$content"
}

download_video