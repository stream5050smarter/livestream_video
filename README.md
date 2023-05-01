# playlist4whisper GUI

"Playlist4Whisper" is an application that displays a playlist for "livestream_video.sh". It plays an online video and uses AI technology to transcribe the audio into text. It supports multi-instance and multi-user execution, and allows for changing options per channel and global options.

Author: Antonio R. Version: 1.28 License: MIT


Usage: 

python playlist4whisper.py 

The program will load default playlist.m3u 

For multi-instances with SMPlayer: Go to Preferences - Interface - Instances, and turn off the option to use only one instance.

#
The application has a simple GUI using Python and the Tkinter library. It transcribes livestreams by feeding the output of ffmpeg to whisper.cpp, based on "livestream.sh" from whisper.cpp.

This program depends on other Linux programs and their libraries, such as Python, whisper.cpp and mpv. For example, Ubuntu Linux users can install the following packages:

sudo apt-get install mpv smplayer ffmpeg python3-tk

To ensure proper functioning of this GUI, all whisper.cpp files (from the official releases), as well as the script livestream_video.sh, should be copied to the same location as playlist4whisper.py. The main executable of whisper.cpp, which is the primary example, should be in the same directory with the default executable name 'main'. Additionally, the Whisper model file from OpenAI should be placed in the "models" subdirectory with the correct format and name, as specified in the Whisper.cpp repository. This can be done using terminal commands such as the following examples:

make tiny.en

make small


playlist4whisper.py dependes on (smplayer, mpv or mplayer) video player and (gnome-terminal or konsole or xfce4-terminal).
#
# livestream_video.sh

livestream_video.sh is a linux script to transcribe video livestream by feeding ffmpeg output to whisper.cpp at regular intervals, based on livestream.sh from whisper.cpp:

https://github.com/ggerganov/whisper.cpp

#

This Linux script adds some new features:

-Support for multi-instance and multi-user execution (For SMPlayer: Go to Preferences -> Interface -> Instances, and turn off the option to use only one instance)

-Language command-line option "auto" (for autodetection), "en," "es," "fr," "de," "iw," "ar," etc., and "translate" for translation to English.


#

Usage: ./livestream_video.sh stream_url [step_s] [model] [language] [translate]

  Example (defaults if no options are specified):
  
    ./livestream_video.sh https://cbsnews.akamaized.net/hls/live/2020607/cbsnlineup_8/master.m3u8 4 base auto


Step:
Size of the parts into which videos are divided for inference, size in seconds.

Whisper models:
tiny.en, tiny, base.en, base, small.en, small, medium.en, medium, large-v1, large

Whisper languages:

Autodetected (auto), English (en), Chinese (zh), German (de), Spanish (es), Russian (ru), Korean (ko), French (fr), Japanese (ja), Portuguese (pt), Catalan (ca), Dutch (nl), Arabic (ar), Italian (it), Hebrew (iw), Ukrainian (uk), Romanian (ro), Swedish (sv), Indonesian (id), Hindi (hi), Finnish (fi), Vietnamese (vi), Hebrew (iw), Ukrainian (uk), Greek (el), Malay (ms), Czech (cs), Romanian (ro), Danish (da), Hungarian (hu), Tamil (ta), Norwegian (no), Thai (th), Urdu (ur), Croatian (hr), Bulgarian (bg), Lithuanian (lt), Latin (la), Maori (mi), Malayalam (ml), Welsh (cy), Slovak (sk), Telugu (te), Persian (fa), Latvian (lv), Bengali (bn), Serbian (sr), Azerbaijani (az), Slovenian (sl), Kannada (kn), Estonian (et), Macedonian (mk), Breton (br), Basque (eu), Icelandic (is), Armenian (hy), Nepali (ne), Mongolian (mn), Bosnian (bs), Kazakh (kk), Albanian (sq), Swahili (sw), Galician (gl), Marathi (mr), Punjabi (pa), Sinhala (si), Khmer (km), Shona (sn), Yoruba (yo), Somali (so), Afrikaans (af), Occitan (oc), Georgian (ka), Belarusian (be), Tajik (tg), Sindhi (sd), Gujarati (gu), Amharic (am), Yiddish (yi), Lao (lo), Uzbek (uz), Faroese (fo), Haitian Creole (ht), Pashto (ps), Turkmen (tk), Nynorsk (nn), Maltese (mt), Sanskrit (sa), Luxembourgish (lb), Myanmar (my), Tibetan (bo), Tagalog (tl), Malagasy (mg), Assamese (as), Tatar (tt), Hawaiian (haw), Lingala (ln), Hausa (ha), Bashkir (ba), Javanese (jw), Sundanese (su).

translate: The "translate" option provides automatic English translation (only English is available).

#

The majority of online video streams should work, although video streams from YouTube, Twitch, or other online video services are not supported. For Twitch, you can try twitch.sh:

https://github.com/ggerganov/whisper.cpp/tree/master/examples

Recommended Linux video player: SMPlayer based on mvp, or any other video player based on mpv, due to its capabilities to timeshift online streams for synchronized live video with the transcription.

#

## playlist4whisper GUI Screenshots:
![Screenshot](https://github.com/antor44/livestream_video/blob/main/whisper_TV8.jpg)
#
![Screenshot](https://github.com/antor44/livestream_video/blob/main/whisper_TV9.jpg)
#
![Screenshot](https://github.com/antor44/livestream_video/blob/main/whisper_TV6.jpg)
#
![Screenshot](https://github.com/antor44/livestream_video/blob/main/whisper_TV5.jpg)
#
## livestream_video.sh screenshots:
![Screenshot](https://github.com/antor44/livestream_video/blob/main/whisper_TV.jpg)
#
![Screenshot](https://github.com/antor44/livestream_video/blob/main/whisper_TV2.jpg)
#
![Screenshot](https://github.com/antor44/livestream_video/blob/main/whisper_TV3.jpg)
#
![Screenshot](https://github.com/antor44/livestream_video/blob/main/whisper_TV4.jpg)

#
# To Do List

- Silence detection for splitting audio into chunks
- Temporal storage of the transcription text, take them into account for AI
- Add option for video player/non-player mode
- Quantized models support
- GPU/ANE acceleration support
- YouTube and Twitch support
- ...

#
# FAQ

**Q: Why is the program not working?**

A: There could be various reasons. This script/program depends on other Linux programs and their libraries, such as whisper.cpp and mpv. The main executable of whisper.cpp, which is the primary example, should be compiled and placed in the same directory as the script livestream_video.sh. By default, the executable should be named 'main'. Additionally, it is necessary the Whisper model file from OpenAI in the "models" directory with the correct format and name, as specified in the Whisper.cpp repository. This can be done using terminal commands like one of the following examples:

make tiny.en

make small

**Q: Can I run playlist4whisper without using the terminal, from a desktop shortcut on Linux?**

A: Yes, you can run it with the command "python" followed by the full path of playlist4whisper.py, or if you are using an Anaconda environment: "/home/[user]/anaconda3/bin/conda run python /home/[user]/[app directory]/playlist4whisper.py". In both cases, provide the working directory where the program is located. However, even when running it from a desktop shortcut, it is recommended to use the option to run in a terminal to get error information.

**Q: How can I change the size of the transcribed text snippets?**

A: You can change the size of the text snippets in seconds with the "step_s" option, which determines the duration of each part into which the videos are divided for transcription.

**Q: How can I change the size and colors of the transcription text?**

A: You can change the size and colors of the transcription text in the options of the terminal program you are using.

**Q: How can I position the terminal window for transcriptions in a fixed position?**

A: You can use a program for placing windows in Linux, such as devilspie, and configure a name for the terminal window and another for the main program terminal, such as Konsole or Xterm, to avoid name conflicts. For example, a configuration for the Gnome terminal in devilspie would be:

; generated_rule Terminal

( if

( and

( matches (window_name) "Terminal" )

)

( begin

( geometry "+644+831" )

( println "match" )

)

)

**Q: How can I synchronize the video and the transcription?**

A: You can use the pause and forward/backward buttons of the video player to manually synchronize the video and transcription to your desired timing.

**Q: Why does the video and transcription get desynchronized?**

A: The video and transcription applications work independently, each with its own stream of video. Over time, the desynchronization can also vary, choosing a model that is too large for the processor's capabilities can also affect the synchronization.

**Q: The transcriptions I get are not accurate. What could be the issue?**

A: The quality of the transcriptions depends on several factors, especially the size of the model chosen. Larger models generally yield better results, but they also require more processing power. The English models tend to perform better than models for other languages. For languages other than English, you may need to use a larger model. If you choose the option auto for language autodetection or translate for simultaneous translation to English, it may also significantly increase processor consumption.

**Q: In a low-power processor, is it possible to improve transcription in languages other than English?**

A:  Yes, if you have knowledge of Artificial Intelligence programming, you would need to fine-tune a default model by retraining the model with a dataset of voices along with their transcriptions in a specific language. These datasets can be found online, as well as sample codes for fine-tuning a Whisper model.

**Q: Neither smplayer nor mplayer work with online TV?**

A: This program uses the system's installed versions of mpv or mplayer, not the python versions installed with pip or Anaconda. The installed version of mplayer may not support online video streams, depending on how it was compiled or its configurations, or there may be conflicts with video encoding libraries used by mplayer. In general, mpv is a better option than mplayer, or if you prefer smplayer, make sure it is configured to use mpv.

**Q: Is this program legal to watch TV channels?**

A: Yes, of course, many of the URLs of channels that you find published on the internet are proactively accessible for free use thanks to companies, governments or public institutions, as long as it is for personal use only. Channels that may be restricted to a country or region for copyright reasons cannot be viewed, and the broadcasting company blocks viewers with IPs from other countries. However, the playlists that are found on the internet may contain some channels with legality that is not entirely clear, even if their URLs are publicly known, it is likely that direct distribution of the signal or commercialization of the television channel is not allowed.
