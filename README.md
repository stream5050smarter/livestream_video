# livestream_video.sh

Linux script/program to transcribe video livestream by feeding ffmpeg output to whisper.cpp at regular intervals, based on livestream.sh from whisper.cpp:

https://github.com/ggerganov/whisper.cpp

#

This Linux script adds some new features:

-Language command-line option: auto (for autodetection), en, es, fr, de, iw, ar, etc.

-Translate to English when auto is selected

#

Usage: ./livestream_video.sh stream_url [step_s] [model] [language]

  Example (defaults if no options are specified):
  
    ./livestream_video.sh https://cbsnews.akamaized.net/hls/live/2020607/cbsnlineup_8/master.m3u8 3 tiny.en en


Step:
Size of the parts into which videos are divided for inference, size in seconds.

Whisper models:
tiny.en, tiny, base.en, base, small.en, small, medium.en, medium, large-v1, large

Whisper languages:

Autodetected (auto), English (en), Chinese (zh), German (de), Spanish (es), Russian (ru), Korean (ko), French (fr), Japanese (ja), Portuguese (pt), Catalan (ca), Dutch (nl), Arabic (ar), Italian (it), Hebrew (iw), Ukrainian (uk), Romanian (ro), Persian (fa), Swedish (sv), Indonesian (id), Hindi (hi), Finnish (fi), Vietnamese (vi), Hebrew (iw), Ukrainian (uk), Greek (el), Malay (ms), Czech (cs), Romanian (ro), Danish (da), Hungarian (hu), Tamil (ta), Norwegian (no), Thai (th), Urdu (ur), Croatian (hr), Bulgarian (bg), Lithuanian (lt), Latin (la), Maori (mi), Malayalam (ml), Welsh (cy), Slovak (sk), Telugu (te), Persian (fa), Latvian (lv), Bengali (bn), Serbian (sr), Azerbaijani (az), Slovenian (sl), Kannada (kn), Estonian (et), Macedonian (mk), Breton (br), Basque (eu), Icelandic (is), Armenian (hy), Nepali (ne), Mongolian (mn), Bosnian (bs), Kazakh (kk), Albanian (sq), Swahili (sw), Galician (gl), Marathi (mr), Punjabi (pa), Sinhala (si), Khmer (km), Shona (sn), Yoruba (yo), Somali (so), Afrikaans (af), Occitan (oc), Georgian (ka), Belarusian (be), Tajik (tg), Sindhi (sd), Gujarati (gu), Amharic (am), Yiddish (yi), Lao (lo), Uzbek (uz), Faroese (fo), Haitian Creole (ht), Pashto (ps), Turkmen (tk), Nynorsk (nn), Maltese (mt), Sanskrit (sa), Luxembourgish (lb), Myanmar (my), Tibetan (bo), Tagalog (tl), Malagasy (mg), Assamese (as), Tatar (tt), Hawaiian (haw), Lingala (ln), Hausa (ha), Bashkir (ba), Javanese (jw), Sundanese (su).

#

Most video streams should work.

Recommended Linux video player: SMPlayer based on mvp, or any other video player based on mplayer, due to its capabilities to timeshift online streams for synchronized live video with the transcription.

## Screenshot:

![Screenshot](https://github.com/antor44/livestream_video/blob/main/whisper_TV.jpg)

#
# To Do List

- Advanced GUI, standalone application
- Fix video desynchronization issue
- GPU acceleration support
- Cross-platform compatibility

#
# FAQ

**Q: Why is the program not working?**

A: There could be various reasons. This script/program depends on other Linux programs and their libraries, such as whisper.cpp and mpv. The script should be in the same directory as the compiled executable of whisper.cpp, which should have the default name "main". Additionally, it is necessary to download the Whisper model file from OpenAI and place it in the "models" directory with the correct format and name, as specified in the script available in the Whisper.cpp repository. This can be done using the following terminal commands:

make tiny.en

make small

**Q: How to synchronize the video and transcription?**

A: You can use the pause and forward/backward buttons of the video player to achieve the desired synchronization.

**Q: Why does the video and transcription get desynchronized?**

A: The video player and transcription application work independently, each with its own video stream. Over time, desynchronization can occur due to the method used to split the audio into chunks for transcription. It can also be affected by choosing a model that is too large for the processor capabilities.

**Q: The transcriptions I get are not accurate?**

A: The quality of transcriptions depends on several factors, especially the size of the chosen model. Larger models tend to perform better, but they also require more processing power. The English models generally work better than models in other languages. For example, for Spanish it is recommended to use at least the base or small model, and for other languages, a larger model may be necessary. If simultaneous translation to English is selected, it may also consume a significant amount of processor resources.


