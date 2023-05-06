#!/bin/bash
#
# livestream_video.sh v. 1.34
#
#Transcribe video livestream by feeding ffmpeg output to whisper.cpp at regular intervals, based on livestream.sh from whisper.cpp
#
#This Linux script adds some new features:
#
#-Support for multi-instance and multi-user execution
#-Support for IPTV, YouTube and Twitch
#-Language command-line option "auto" (for autodetection), "en," "es," "fr," "de," "iw," "ar," etc., and "translate" for translation to English.
#
# Usage: ./livestream_video.sh stream_url [step_s] [model] [language] [translate]
#
#   Example (defaults if no options are specified):
#
#    ./livestream_video.sh https://cbsnews.akamaized.net/hls/live/2020607/cbsnlineup_8/master.m3u8 4 base auto
#
#
# Script and Whisper executable (main), and models directory with at least one archive model, must reside in the same directory.
#


set -eo pipefail

url_default="https://cbsnews.akamaized.net/hls/live/2020607/cbsnlineup_8/master.m3u8"
fmt=mp3 # the audio format
step_s=4
model="base"
language="auto"
translate=""

# Whisper languages:
# Autodetected (auto), English (en), Chinese (zh), German (de), Spanish (es), Russian (ru), Korean (ko), French (fr), Japanese (ja), Portuguese (pt), Catalan (ca), Dutch (nl), Arabic (ar), Italian (it), Hebrew (iw), Ukrainian (uk), Romanian (ro), Swedish (sv), Indonesian (id), Hindi (hi), Finnish (fi), Vietnamese (vi), Hebrew (iw), Ukrainian (uk), Greek (el), Malay (ms), Czech (cs), Romanian (ro), Danish (da), Hungarian (hu), Tamil (ta), Norwegian (no), Thai (th), Urdu (ur), Croatian (hr), Bulgarian (bg), Lithuanian (lt), Latin (la), Maori (mi), Malayalam (ml), Welsh (cy), Slovak (sk), Telugu (te), Persian (fa), Latvian (lv), Bengali (bn), Serbian (sr), Azerbaijani (az), Slovenian (sl), Kannada (kn), Estonian (et), Macedonian (mk), Breton (br), Basque (eu), Icelandic (is), Armenian (hy), Nepali (ne), Mongolian (mn), Bosnian (bs), Kazakh (kk), Albanian (sq), Swahili (sw), Galician (gl), Marathi (mr), Punjabi (pa), Sinhala (si), Khmer (km), Shona (sn), Yoruba (yo), Somali (so), Afrikaans (af), Occitan (oc), Georgian (ka), Belarusian (be), Tajik (tg), Sindhi (sd), Gujarati (gu), Amharic (am), Yiddish (yi), Lao (lo), Uzbek (uz), Faroese (fo), Haitian Creole (ht), Pashto (ps), Turkmen (tk), Nynorsk (nn), Maltese (mt), Sanskrit (sa), Luxembourgish (lb), Myanmar (my), Tibetan (bo), Tagalog (tl), Malagasy (mg), Assamese (as), Tatar (tt), Hawaiian (haw), Lingala (ln), Hausa (ha), Bashkir (ba), Javanese (jw), Sundanese (su).

languages=( "auto" "en" "zh" "de" "es" "ru" "ko" "fr" "ja" "pt" "tr" "pl" "ca" "nl" "ar" "sv" "it" "id" "hi" "fi" "vi" "iw" "uk" "el" "ms" "cs" "ro" "da" "hu" "ta" "no" "th" "ur" "hr" "bg" "lt" "la" "mi" "ml" "cy" "sk" "te" "fa" "lv" "bn" "sr" "az" "sl" "kn" "et" "mk" "br" "eu" "is" "hy" "ne" "mn" "bs" "kk" "sq" "sw" "gl" "mr" "pa" "si" "km" "sn" "yo" "so" "af" "oc" "ka" "be" "tg" "sd" "gu" "am" "yi" "lo" "uz" "fo" "ht" "ps" "tk" "nn" "mt" "sa" "lb" "my" "bo" "tl" "mg" "as" "tt" "haw" "ln" "ha" "ba" "jw" "su" )

# Whisper models
models=( "tiny.en" "tiny" "base.en" "base" "small.en" "small" "medium.en" "medium" "large-v1" "large" )
suffixes=( "-q4_0" "-q4_1" "-q4_2" "-q5_0" "-q5_1" "-q8_0" )

model_list=()

for modele in "${models[@]}"; do
 model_list+=("$modele")
 for suffix in "${suffixes[@]}"; do
   model_list+=("${modele}${suffix}")
 done
done


check_requirements()
{
    if ! command -v ./main &>/dev/null; then
        echo "whisper.cpp main executable is required (make)"
        exit 1
    fi

    if ! command -v ffmpeg &>/dev/null; then
        echo "ffmpeg is required (https://ffmpeg.org)"
        exit 1
    fi
}


# list available languages
function list_languages {
    printf "\n"
    printf "  Available languages:"
    for language in "${languages[@]}"; do
        printf " $language"
    done
    printf "\n\n"
}

usage()
{
    echo "Usage: $0 stream_url [step_s] [model] [language] [translate]"
    echo ""
    echo "  Example:"
    echo "    $0 $url $step_s $model $language $translate"
    echo ""

    # list available models

    printf "\n"
    printf "  Available models:"
    for modele in "${model_list[@]}"; do
        printf " $modele"
    done
    printf "\n\n"

    list_languages

}


check_requirements


while (( "$#" )); do
    case $1 in
        *://* ) url=$1;;
        [2-9]|[1-5][0-9]|60 ) step_s=$1;;
        translate ) translate=$1;;
        *)
            if [[ "${model_list[@]}" =~ (^|[[:space:]])"$1"($|[[:space:]]) ]]; then
                model=$1
            elif [[ "${languages[@]}" =~ (^|[[:space:]])"$1"($|[[:space:]]) ]]; then
                language=$1
            else
                echo ""; echo "*** Wrong option $1"; echo ""; usage; exit 1
            fi
            ;;
    esac
    shift
done



if [ ! -f ./models/ggml-${model}.bin ]; then
    echo ""
    echo "*** No file /models/ggml-${model}.bin for model ${model}"
    echo ""
    usage

    exit 1
fi

mypid=$(pgrep -n -f "livestream_video.sh")

if [ -n "$mypid" ]; then
    if [ -e "/tmp/whisper-live_${mypid}.wav" ] && ! [ -w "/tmp/whisper-live_${mypid}.wav" ]; then
      echo ""
      echo "Error: Permission denied to access files /tmp/whisper-live_${mypid}.*"
      echo ""
      exit 1
    else
      echo ""
      echo "New script PID: $mypid"
    fi
else
  echo ""
  echo "An unknown error has occurred."
  echo ""
  exit 1
fi


if [ -z "$url" ]; then
    url="$url_default"
    echo " *** No url specified, using default: $url"
    echo ""
else
    echo " *** url specified by user: $url"
    echo ""
fi

running=1

trap "running=0" SIGINT SIGTERM



# if translate then translate to english

if [[ $translate == "translate" ]]; then
    translate="-tr"
    printf "[+] Transcribing stream with model '$model', step_s $step_s, language '$language', translate to english (press Ctrl+C to stop):\n\n"
else
    translate=""
    printf "[+] Transcribing stream with model '$model', step_s $step_s, language '$language', NO translate to english (press Ctrl+C to stop):\n\n"
fi


# continuous stream in native fmt (this file will grow forever!)

case $url in
    *youtube* | *youtu.be* )
        if ! command -v yt-dlp &>/dev/null; then
            echo "yt-dlp is required (https://github.com/yt-dlp/yt-dlp)"
            exit 1
        fi
        ffmpeg -loglevel quiet -y -probesize 32 -i $(yt-dlp -i -f 'bestaudio/worst[height<=1080]' -g $url) -map 0:a:0 /tmp/whisper-live0_${mypid}.${fmt} &
        if [ $? -ne 0 ]; then
            printf "Error: ffmpeg failed to capture audio stream\n"
            exit 1
        fi
        ;;
    *twitch* )
        if ! command -v streamlink &>/dev/null; then
            echo "streamlink is required (https://streamlink.github.io)"
            exit 1
        fi
        streamlink $url best -O 2>/dev/null | ffmpeg -loglevel quiet -i - -y -probesize 32 /tmp/whisper-live0_${mypid}.${fmt} &
        if [ $? -ne 0 ]; then
            printf "Error: ffmpeg failed to capture audio stream\n"
            exit 1
        fi
        ;;
    * )
    ffmpeg -loglevel quiet -y -probesize 32 -i $url -map 0:a:0 /tmp/whisper-live0_${mypid}.${fmt} &
        if [ $? -ne 0 ]; then
            printf "Error: ffmpeg failed to capture audio stream\n"
            exit 1
        fi
        ;;
esac


printf "Buffering audio. Please wait...\n\n"
sleep $(($step_s+1))

# do not stop script on error
set +e

i=0
SECONDS=0
while [ $running -eq 1 ]; do
    # extract the next piece from the main file above and transcode to wav. -ss sets start time, -0.x seconds adjust
    err=1
    while [ $err -ne 0 ]; do
        if [ $i -gt 0 ]; then
            ffmpeg -loglevel quiet -v error -noaccurate_seek -i /tmp/whisper-live0_${mypid}.${fmt} -y -ar 16000 -ac 1 -c:a pcm_s16le -ss $(echo "$i * $step_s - 0.8" | bc) -t $(echo "$step_s + 0.0" | bc) /tmp/whisper-live_${mypid}.wav 2> /tmp/whisper-live_${mypid}.err
        else
            ffmpeg -loglevel quiet -v error -noaccurate_seek -i /tmp/whisper-live0_${mypid}.${fmt} -y -ar 16000 -ac 1 -c:a pcm_s16le -ss 0 -t $(echo "$step_s - 0.8" | bc) /tmp/whisper-live_${mypid}.wav 2> /tmp/whisper-live_${mypid}.err
        fi
        err=$(cat /tmp/whisper-live_${mypid}.err | wc -l)
    done

    ./main -l ${language} ${translate} -t 4 -m ./models/ggml-${model}.bin -f /tmp/whisper-live_${mypid}.wav --no-timestamps -otxt 2> /tmp/whispererr_${mypid} | tail -n 1

    while [ $SECONDS -lt $((($i+1)*$step_s)) ]; do
        sleep 0.5
    done
    ((i=i+1))
done

killall -v ffmpeg
killall -v main
