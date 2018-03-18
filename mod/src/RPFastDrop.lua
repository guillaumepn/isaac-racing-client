local RPFastDrop = {}

--
-- Includes
--

local RPGlobals = require("src/rpglobals")
local RPSaveDat = require("src/rpsavedat")

-- 0 is selecting the fast-drop hotkey (initial state)
-- 1 is selecting the Schoolbag switch hotkey
-- 2 is begin to fade out back to the main menu
-- 3 is fading out
RPFastDrop.challengeState = 0
RPFastDrop.challengeFramePressed = 0

--
-- Fast drop functions
--

-- Check for item drop inputs (fast-drop)
function RPFastDrop:CheckDropInput()
  -- Local variables
  local game = Game()
  local room = game:GetRoom()
  local player = game:GetPlayer(0)

  -- If they do not have a hotkey bound for fast-drop, do not enable the feature
  if RPGlobals.race.hotkeyDrop == 0 then
    return
  end

  -- Check for the input
  -- (use "IsActionPressed()" instead of "IsActionTriggered()" because it is faster to drop on press than on release)
  if Input.IsButtonPressed(RPGlobals.race.hotkeyDrop, player.ControllerIndex) == false then -- 11
    return
  end

  -- Pocket items (cards, pills, runes, etc.)
  local pos1 = room:FindFreePickupSpawnPosition(player.Position, 0, true)
  player:DropPoketItem(0, pos1) -- Spider misspelled this
  local pos2 = room:FindFreePickupSpawnPosition(player.Position, 0, true)
  player:DropPoketItem(1, pos2)

  -- Trinkets (this does handle the Tick properly)
  local pos3 = room:FindFreePickupSpawnPosition(player.Position, 0, true)
  player:DropTrinket(pos3, false)
  local pos4 = room:FindFreePickupSpawnPosition(player.Position, 0, true)
  player:DropTrinket(pos4, false)
end

--
-- The "Change Keybindings" custom challenge
--

function RPFastDrop:PostGameStarted()
  -- Local variables
  local game = Game()
  local room = game:GetRoom()
  local player = game:GetPlayer(0)
  local challenge = Isaac.GetChallenge()

  if challenge ~= Isaac.GetChallengeIdByName("Change Keybindings") then
    return
  end

  -- Reset variables used in the challenge
  RPFastDrop.challengeState = 0
  RPFastDrop.challengeFramePressed = 0
  Isaac.DebugString("Entered the \"Change Keybindings\" custom challenge.")

  -- Remove all of the doors
  for i = 0, 3 do
    room:RemoveDoor(i)
  end

  -- Make the player invisible
  player.Position = room:GetCenterPos()
  player.SpriteScale = Vector(0, 0)
end

function RPFastDrop:PostRender()
  -- Local variables
  local game = Game()
  local gameFrameCount = game:GetFrameCount()
  local challenge = Isaac.GetChallenge()

  if challenge ~= Isaac.GetChallengeIdByName("Change Keybindings") then
    return
  end

  -- Wait a moment just in case they were mashing stuff while it was loading
  if game:GetFrameCount() == 0 then
    return
  end

  if RPFastDrop.challengeState == 2 then
    RPFastDrop.challengeState = 3
    game:Fadeout(0.05, RPGlobals.FadeoutTarget.FADEOUT_MAIN_MENU)
  elseif RPFastDrop.challengeState == 3 then
    return
  end

  -- Wait a moment if they just set a hotkey
  if RPFastDrop.challengeFramePressed + 10 >= gameFrameCount then
    return
  end

  local textColor = {
    1,
    1,
    1,
    2,
  }
  local text1
  local text2 = ""
  if RPFastDrop.challengeState == 0 then
    if RPGlobals.race.hotkeyDrop == 0 then
      text1 = "The custom fast-drop hotkey is not bound."
    else
      text1 = "The custom fast-drop hotkey is currently bound to:"
      text2 = RPFastDrop:GetKeyName(RPGlobals.race.hotkeyDrop) ..
              " (code: " .. tostring(RPGlobals.race.hotkeyDrop) .. ")"
    end
  elseif RPFastDrop.challengeState == 1 then
    if RPGlobals.race.hotkeySwitch == 0 then
      text1 = "The custom Schoolbag-switch hotkey is not bound."
    else
      text1 = "The custom Schoolbag-switch hotkey is currently bound to:"
      text2 = RPFastDrop:GetKeyName(RPGlobals.race.hotkeySwitch) ..
              " (code: " .. tostring(RPGlobals.race.hotkeySwitch) .. ")"
    end
  end
  Isaac.RenderText(text1, 100, 90, textColor[1], textColor[2], textColor[3], textColor[4])
  Isaac.RenderText(text2, 100, 110, textColor[1], textColor[2], textColor[3], textColor[4])
  Isaac.RenderText("Press the desired key now.", 100, 150, textColor[1], textColor[2], textColor[3], textColor[4])
  Isaac.RenderText("(Or press F12 to keep the vanilla behavior.)", 100, 170,
                   textColor[1], textColor[2], textColor[3], textColor[4])

  for k, v in pairs(Keyboard) do
    if Input.IsButtonPressed(v, 0) then
      if RPFastDrop.challengeState == 0 then
        RPGlobals.race.hotkeyDrop = v
        if v == Keyboard.KEY_F12 then -- 301
          RPGlobals.race.hotkeyDrop = 0
        end
        Isaac.DebugString("New drop hotkey: " .. tostring(RPGlobals.race.hotkeyDrop))
        RPFastDrop.challengeState = 1
      elseif RPFastDrop.challengeState == 1 then
        RPGlobals.race.hotkeySwitch = v
        if v == Keyboard.KEY_F12 then -- 301
          RPGlobals.race.hotkeySwitch = 0
        end
        Isaac.DebugString("New switch hotkey: " .. tostring(RPGlobals.race.hotkeySwitch))
        RPFastDrop.challengeState = 2
      end
      RPSaveDat:Save()
      RPFastDrop.challengeFramePressed = gameFrameCount
    end
  end
end

function RPFastDrop:GetKeyName(keyCode)
  for k, v in pairs(Keyboard) do
    if v == keyCode then
      return k:sub(5)
    end
  end

  return "not found"
end

return RPFastDrop
