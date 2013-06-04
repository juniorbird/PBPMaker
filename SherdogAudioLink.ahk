#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force ; only run 1 instance
#NoTrayIcon

; You don't dim variables in AHK but I'm going to review the major ones here for maintainability
; fightIndex This will hold our "table of contents" to fights at the top of the page
; fightRecaps This will hold our list of fight recaps

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Put together our GUI
; An input line, a submit line, and a read-only textarea that the user can copy and paste from
Gui, Show, w500 h407, Audio Embed Builder
Gui, Add, Text,, Enter Audio URL:
Gui, Add, Edit, r1 w480 vtheAudio
Gui, Add, Button, Default gConvertAudio, Convert to Embed
Gui, Add, Text, y+10, Your Embed Code:
Gui, Add, Edit, r20 w480 vaudioEmbed
Gui, Add, Button, gClipCard, Copy HTML
Gui, Add, Button, gQuitMe x+385, Exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make the GUI do things
;
; When the user clicks the Convert to Embed button, take the contents of the Audio URL field and:
;	1. Wrap it in the right HTML
;
ConvertAudio:
	If A_GuiEvent = Normal ; This makes this button fire only onclick and not on creation
		{
		Gui, Submit, NoHide

		fullEmbed = 			<div class="player-audio">`n
		fullEmbed = %fullEmbed%	<div id="jquery_jplayer_1" class="jplayer" data-audio-url="%theAudio%"></div>`n
		fullEmbed = %fullEmbed%	<div id="jp_container_1" class="jp-audio">`n
		fullEmbed = %fullEmbed%	<div class="jp-type-single">`n
		fullEmbed = %fullEmbed%	<div class="jp-gui jp-interface">`n
		fullEmbed = %fullEmbed%	<div class="jp-player-box jp-current-time"></div>`n
		fullEmbed = %fullEmbed%	<div class="jp-progress">`n
		fullEmbed = %fullEmbed%	<div class="jp-seek-bar">`n
		fullEmbed = %fullEmbed%	<div class="jp-play-bar"></div>`n
		fullEmbed = %fullEmbed%	</div>`n
		fullEmbed = %fullEmbed%	</div>`n
		fullEmbed = %fullEmbed%	<div class="jp-player-box jp-duration"></div>`n
		fullEmbed = %fullEmbed%	<div class="jp-controls">`n
		fullEmbed = %fullEmbed%	<a href="javascript:`;" class="jp-play" tabindex="1" title="Play"><i class="icon-play">&nbsp`;</i></a>`n
		fullEmbed = %fullEmbed%	<a href="javascript:`;" class="jp-pause" tabindex="1" title="Pause"><i class="icon-pause">&nbsp`;</i></a>`n
		fullEmbed = %fullEmbed%	<a href="javascript:`;" class="jp-stop" tabindex="1" title="Stop"><i class="icon-stop">&nbsp`;</i></a>`n
		fullEmbed = %fullEmbed%	<a href="javascript:`;" class="jp-mute" tabindex="1" title="Mute"><i class="icon-volume-up">&nbsp`;</i></a>`n
		fullEmbed = %fullEmbed%	<a href="javascript:`;" class="jp-unmute" tabindex="1" title="Unmute"><i class="icon-volume-off">&nbsp`;</i></a>`n
		fullEmbed = %fullEmbed%	<span class="jp-volume-bar">`n
		fullEmbed = %fullEmbed%	<span class="jp-volume-seek-bar">`n
		fullEmbed = %fullEmbed%	<span class="jp-volume-bar-value"></span>`n
		fullEmbed = %fullEmbed%	</span>`n
		fullEmbed = %fullEmbed%	</span>`n
		fullEmbed = %fullEmbed%	</div>`n
		fullEmbed = %fullEmbed%	</div>`n
		fullEmbed = %fullEmbed%	<div class="jp-no-solution">`n
		fullEmbed = %fullEmbed%	<span>Update Required</span>`n
		fullEmbed = %fullEmbed%	To play the media you will need to either update your browser to a recent version or update your <a href="http://get.adobe.com/flashplayer/" target="_blank">Flash plugin</a>.`n
		fullEmbed = %fullEmbed%	</div>`n
		fullEmbed = %fullEmbed%	</div>`n
		fullEmbed = %fullEmbed%	</div>`n
		fullEmbed = %fullEmbed%	<div class="clear"></div>`n
		fullEmbed = %fullEmbed%	</div>`n

		guicontrol,, audioEmbed, %fullEmbed%
		guicontrol,, theAudio, 
	}
Return

; User can click a button to copy all data
ClipCard:
	clipboard = %fullEmbed%
Return

; An exit button for convenience
QuitMe:
	ExitApp
Return
