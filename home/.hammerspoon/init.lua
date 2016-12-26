local pressedKeyTable = {}
-- TODO: Consider about consumed per keys is necessary or not.
local consumed = false
local keyCodeTable = {}
keyCodeTable[0x66] = true -- EISUU
keyCodeTable[0x68] = true -- KANA

eventtap = hs.eventtap.new({ hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp }, function(event)
    local keyCode = event:getKeyCode()
    if keyCodeTable[keyCode] == true then
        if event:getType() == hs.eventtap.event.types.keyDown then
            pressedKeyTable[keyCode] = true
            return true
        end
        pressedKeyTable[keyCode] = false
        local currentConsumed = consumed
        consumed = false
        if currentConsumed == true then
            return true
        end
        -- TODO: Modifier
        return true, {
            hs.eventtap.event.newKeyEvent({}, keyCode, true),
            hs.eventtap.event.newKeyEvent({}, keyCode, false)
        }
    end
    local somePressed = false
    for keyCode, pressed in pairs(pressedKeyTable) do
        if pressed == true then
            somePressed = true
            break
        end
    end
    if somePressed == true then
        consumed = true
        local flags = event:getFlags()
        flags["alt"] = true
        event:setFlags(flags)
    end
end)
eventtap:start()