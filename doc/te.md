# TE Text Editor

## Command Line

`.te` \[*path*/\]*filename* ~~[*linenumber*]~~

## General Description

A tool for editing esxDOS text files, expecially, though not exclusively configuration files.
It works with both CR (ZX Spectrum style) and LF (Unix style) line endings. MSDOS style line endings
CR + LF look like double spacing, but can be managed with some care as well.    

The user interface mostly follows ZX conventions, with an editing area (console) at the bottom
of the screen and the edited document at the top. There is no explicit SAVE functionality, hitting
ENTER immediately commits the changes into the file. In case of a crash, the file might be available
at the /tmp/te.tmp location.                                  

The editor buffer resides in esxDOS memory, only the edited line takes space from the ZX
Spectrum's OS, so it is possible to edit large files even when there is very little free memory 
left.

## Keyboard

Most keys work like in the ZX Spectrum's BASIC editor, with the differences summarized     
in this table:

| Key | Function
| --- | ---
| BREAK | exit `te`
| UP arrow | line cursor one line UP **or** character cursor HOME
| DOWN arrow | line cursor one line DOWN **or** character cursor END
| LEFT arrow | character cursor LEFT **or** ~~page UP~~
| RIGHT arrow | character cursor RIGHT **or** ~~page DOWN~~ 
| DELETE | delete character to the left of character cursor
| G mode DELETE | delete all characters to the left of character cursor
| G mode 0 | delete all characters after character cursor
| EDIT | edit line pointed by line cursor
| ss + SPACE | insert line pointed by line cursor into edited line at character cursor
| ENTER | insert edited line into file **or** replace edited line
| G mode ENTER | split edited line at character cursor and insert both into file
| cs + ENTER | join edited line with the one pointed by line cursor
| ss + ENTER | like ENTER, but toggle line ending between CR (`CHR$ 13`) and LF (`CHR$ 10`)
