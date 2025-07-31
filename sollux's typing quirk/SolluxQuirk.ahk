#Requires AutoHotkey v1.1.33+
#SingleInstance Force
#InstallKeybdHook
#Persistent
SendMode Input
Menu, Tray, Tip, Sollux Quirk Replacement
global debugMode := false

ProcessText(text) {
    if (!text) {
        return text
    }

    try {
        urlRegex := "i)(https?://[^\s]+|www\.[^\s]+)"
        protectedText := ""
        pos := 1
        
        while (pos <= StrLen(text)) {
            foundPos := RegExMatch(text, urlRegex, match, pos)
            if (!foundPos) {
                segment := SubStr(text, pos)
                ; Apply replacements to non-URL segment
                segment := RegExReplace(segment, "i", "ii", "All")
                segment := RegExReplace(segment, "s", "2", "All")
                segment := RegExReplace(segment, "\bto\b", "two", "All")
                segment := RegExReplace(segment, "\btoo\b", "two", "All")
                protectedText .= segment
                break
            }
            
            if (foundPos > pos) {
                nonUrlSegment := SubStr(text, pos, foundPos - pos)
                ; Apply replacements to non-URL segment
                nonUrlSegment := RegExReplace(nonUrlSegment, "i", "ii", "All")
                nonUrlSegment := RegExReplace(nonUrlSegment, "s", "2", "All")
                nonUrlSegment := RegExReplace(nonUrlSegment, "\bto\b", "two", "All")
                nonUrlSegment := RegExReplace(nonUrlSegment, "\btoo\b", "two", "All")
                protectedText .= nonUrlSegment
            }
            
            protectedText .= match
            pos := foundPos + StrLen(match)
        }
        
        return protectedText
    }
    catch {
        return text
    }
}

^+q::
    oldClipboard := ClipboardAll
    Clipboard := ""
    SendInput, ^c
    ClipWait, 0.4

    if (Clipboard) {
        processedText := ProcessText(Clipboard)
        if (processedText != Clipboard) {
            Sleep, 194
            Clipboard := processedText
            Sleep, 201
            SendInput, ^v
            Sleep, 228
        }
    }
    Clipboard := oldClipboard
    oldClipboard := ""
return

#if debugMode
^!d::
    MsgBox, Debug Info:`n`nClipboard: %Clipboard%
#if