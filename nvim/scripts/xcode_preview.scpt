on run {filePath}
    tell application "Xcode"
        activate
        open (filePath as POSIX file)

        tell application "System Events"
            tell process "Xcode"
                set menuBarItem to menu item "Canvas" of menu 1 of menu bar item "Editor" of menu bar 1
                if not (value of attribute "AXMenuItemMarkChar" of menuBarItem is "✓") then
                    click menuBarItem
                end if
            end tell
        end tell
    end tell
end run

