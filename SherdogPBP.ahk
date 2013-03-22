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
Gui, Show, w500 h550, Fight List
Gui, Add, Text,, Enter Fights:
Gui, Add, Edit, r12 w480 vtheFight
Gui, Add, Button, Default gConvertCard, Convert Fight Card
Gui, Add, Text, y+10, Your HTML:
Gui, Add, Edit, r20 w480 vfightCard
Gui, Add, Button, gClipCard, Copy HTML
Gui, Add, Button, gQuitMe x+385, Exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make the GUI do things
;
; When the user clicks the Add Fight button, take the contents of the Enter Fight field and:
;	1. Make an anchor link of it
;	2. Make an "index" <li> with the anchor link wrapping entered text
;   3. Append the index <li> to fightIndex
; 	4. Make a "recap" with the headline, anchor, and empty rounds and append that to fightRecaps
;		NOTE: we'll assume every fight is 3 rounds since that just means Fridley needs to make 1 fight per event 5 rounds
;	5. Display the index and recap in fightCard so that Fridley can cut-n-paste
;
ConvertCard:
	If A_GuiEvent = Normal ; This makes this button fire only onclick and not on creation
		{
		Gui, Submit, NoHide
		StringSplit, arrFights, theFight, `n, `r

		Loop, %arrFights0%
			{
				thisFight := arrFights%a_index%

				eventIndex :=  eventIndex . makeLI(thisFight) ; create an index entry for this event; works in reverse order so that the headliner card is at the top of the index, but the first fight is at the top of the narrative
				eventUL := makeUL(eventIndex)
				eventRecord := addRounds(makeTitle(thisFight)) . eventRecord ; create a record for this event
			}

		fullCard = 	%eventUL%`n`n%eventRecord% 
		guicontrol,, fightCard, %fullCard%
		guicontrol,, theFight, 
		}
Return

; User can click a button to copy all data
ClipCard:
	clipboard = %fullCard%
Return

; An exit button for convenience
QuitMe:
	ExitApp
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The functions that the button calls

; Turn a fightname into anchor text by changing spaces to dashes, removing periods, and making lowercase
makeAnchor(fight)
	{
		StringReplace, theAnchor, fight, ', , All
		StringReplace, theAnchor, theAnchor, %A_SPACE%vs, , All
		StringReplace, theAnchor, theAnchor, ., , All
		StringReplace, theAnchor, theAnchor, %A_SPACE%, -, All
		StringLower, theAnchor, theAnchor

		return theAnchor
	}

; Append empty rounds to a recap
addRounds(fight)
	{
		theRounds = <strong>Round 1</strong><BR>`n<BR><BR>`n<strong>Round 2</strong><BR>`n<BR><BR>`n<strong>Round 3</strong><BR>`n<BR><BR>
		theRounds = %fight%%theRounds%`n`n

		return theRounds
	}


; Make an H2 title for a fight with an anchor in front to go there
makeTitle(fight)
	{
		theLink := makeAnchor(fight)

		theTitle = <h2>%fight%</h2>
		theTitle = <a name="%theLink%"></a>%theTitle%`n

		return theTitle
	}


; Output a formatted LI for an individual fight
makeLI(fight)
	{
		theLink := makeAnchor(fight)

		theLI = <a href="#%theLink%">%fight%</a> ;need to add in a # before the link!
		theLI = <li>%theLI%</li>

		theLI = `n%theLI%

		return theLI
	}

; Turn the index of fights into a proper UL
makeUL(topindex)
	{
		theUL = <ul>%topindex%`n</ul>

		return theUL
	}