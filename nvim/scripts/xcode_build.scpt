tell application "Xcode" to activate
tell application "System Events"
    keystroke "b" using {command down}
end tell
delay 0.2
tell application "kitty" to activate
