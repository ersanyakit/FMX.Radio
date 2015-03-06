# FMX.Radio
Delphi XE7 Firemonkey Radio Player
Stream data from HTTP and FTP servers (inc. Shoutcast, Icecast & Icecast2), with IDN and proxy server support and adjustable buffering 

#FMX.Radio.Windows
<pre>
1. Download bass24.zip from http://www.un4seen.com (direct link http://uk.un4seen.com/files/bass24.zip ).
2. Extract the archive somewhere, copy extracted bass.dll to your project output directory.
</pre>

#FMX.Radio.Android
Project -> Deployment -> Add Files
<pre>
1 : Library->Android->armeabi
	a : libbass.so
	b : libbass_aac.so	
	c : libbassflac.so
	Remote Path : library\lib\armeabi\
</pre>
<pre>
2 : Library->Android->x86
	a : libbass.so
	b : libbass_aac.so	
	c : libbassflac.so
	Remote Path : library\lib\x86\
</pre>
<pre>
3 : Library->Android->armeabi-v7a
	a : libbass.so
	b : libbass_aac.so	
	c : libbassflac.so
	Remote Path : library\lib\armeabi-v7a\
</pre>
Make sure library files remote path name, must be added in the Deployment window.


#FMX.Radio.IOS

#Bass Audio Library
BASS is an audio library for use in software on several platforms. Its purpose is to provide developers with powerful and efficient sample, stream (MP3, MP2, MP1, OGG, WAV, AIFF, custom generated, and more via OS codecs and add-ons), MOD music (XM, IT, S3M, MOD, MTM, UMX), MO3 music (MP3/OGG compressed MODs), and recording functions. All in a compact DLL that won't bloat your distribution.

#Android
http://www.un4seen.com/forum/?topic=13225

#IOS
http://www.un4seen.com/forum/?topic=10910

#WinCE
http://www.un4seen.com/forum/?topic=9534

#ARMLINUX
http://www.un4seen.com/forum/?topic=13804
