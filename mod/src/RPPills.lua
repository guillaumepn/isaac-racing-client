local RPPills = {}

-- Includes
local RPGlobals = require("src/rpglobals")

-- Constants
RPPills.effects = {
  "Bad Trip",
  "Balls of Steel",
  "Bombs Are Key",
  "Explosive Diarrhea",
  "Full Health",
  "Health Down",
  "Health Up",
  "I Found Pills",
  "Puberty",
  "Pretty Fly",
  "Range Down",
  "Range Up",
  "Speed Down",
  "Speed Up",
  "Tears Down",
  "Tears Up",
  "Luck Down",
  "Luck Up",
  "Telepills",
  "48 Hour Energy",
  "Hematemesis",
  "Paralysis",
  "I can see forever!",
  "Pheromones",
  "Amnesia",
  "Lemon Party",
  "R U a Wizard?",
  "Percs!",
  "Addicted!",
  "Re-Lax",
  "???",
  "One makes you larger",
  "One makes you small",
  "Infested!",
  "Infested?",
  "Power Pill!",
  "Retro Vision",
  "Friends Till The End!",
  "X-Lax",
  "Something's wrong...",
  "I'm Drowsy...",
  "I'm Excited!!!",
  "Gulp!",
  "Horf!",
  "Feels like I'm walking on sunshine!",
  "Vurp!",
}
RPPills.effects[0] = "Bad Gas" -- Lua tables are 1-indexed

function RPPills:PostRender()
  -- This feature is disabled if the Single Player Co-op Babies mod is enabled
  -- (the pills text will overlap with the baby descriptions)
  if SinglePlayerCoopBabies ~= nil then
    return
  end

  -- Only show pill identification if the user is pressing tab
  local tabPressed = false
  for i = 0, 3 do -- There are 4 possible inputs/players from 0 to 3
    if Input.IsActionPressed(ButtonAction.ACTION_MAP, i) then -- 13
      tabPressed = true
      break
    end
  end
  if tabPressed == false then
    return
  end

  -- Don't do anything if we have not taken any pills yet
  if #RPGlobals.run.pills == 0 then
    return
  end

  for i = 1, #RPGlobals.run.pills do
    local pillEntry = RPGlobals.run.pills[i]

    -- Show the pill sprite
    local x = 80
    local y = 77 + (20 * i)
    local pos = Vector(x, y)
    pillEntry.sprite:RenderLayer(0, pos)

    -- Show the pill effect as text
    local effectText = RPPills.effects[pillEntry.effect]
    Isaac.RenderText(effectText, x + 17, y - 7, 1, 1, 1, 2)
  end

end

function RPPills:CheckPHD()
  -- Local variables
  local game = Game()
  local player = game:GetPlayer(0)

  if RPGlobals.run.PHDPills then
    -- We have already converted bad pill effects this run
    return
  end

  -- Check for the PHD / Virgo
  if player:HasCollectible(CollectibleType.COLLECTIBLE_PHD) == false and -- 75
     player:HasCollectible(CollectibleType.COLLECTIBLE_VIRGO) == false then -- 303

    return
  end

  RPGlobals.run.PHDPills = true
  Isaac.DebugString("Converting bad pill effects.")

  -- Change the text for any identified pills
  for i = 1, #RPGlobals.run.pills do
    local pillEntry = RPGlobals.run.pills[i]
    if pillEntry.effect == PillEffect.PILLEFFECT_BAD_TRIP then -- 1
      pillEntry.effect = PillEffect.PILLEFFECT_BALLS_OF_STEEL -- 2
    elseif pillEntry.effect == PillEffect.PILLEFFECT_HEALTH_DOWN then -- 6
      pillEntry.effect = PillEffect.PILLEFFECT_HEALTH_UP -- 7
    elseif pillEntry.effect == PillEffect.PILLEFFECT_RANGE_DOWN then -- 11
      pillEntry.effect = PillEffect.PILLEFFECT_RANGE_UP -- 12
    elseif pillEntry.effect == PillEffect.PILLEFFECT_SPEED_DOWN then -- 13
      pillEntry.effect = PillEffect.PILLEFFECT_SPEED_UP -- 14
    elseif pillEntry.effect == PillEffect.PILLEFFECT_TEARS_DOWN then -- 15
      pillEntry.effect = PillEffect.PILLEFFECT_TEARS_UP -- 16
    elseif pillEntry.effect == PillEffect.PILLEFFECT_LUCK_DOWN then -- 17
      pillEntry.effect = PillEffect.PILLEFFECT_LUCK_UP -- 18
    elseif pillEntry.effect == PillEffect.PILLEFFECT_PARALYSIS then -- 22
      pillEntry.effect = PillEffect.PILLEFFECT_PHEROMONES -- 24
    elseif pillEntry.effect == PillEffect.PILLEFFECT_WIZARD then -- 27
      pillEntry.effect = PillEffect.PILLEFFECT_POWER -- 36
    elseif pillEntry.effect == PillEffect.PILLEFFECT_ADDICTED then -- 29
      pillEntry.effect = PillEffect.PILLEFFECT_PERCS -- 28
    elseif pillEntry.effect == PillEffect.PILLEFFECT_RETRO_VISION then -- 37
      pillEntry.effect = PillEffect.PILLEFFECT_SEE_FOREVER -- 23
    elseif pillEntry.effect == PillEffect.PILLEFFECT_X_LAX then -- 39
      pillEntry.effect = PillEffect.PILLEFFECT_SOMETHINGS_WRONG -- 40
    elseif pillEntry.effect == PillEffect.PILLEFFECT_IM_EXCITED then -- 42
      pillEntry.effect = PillEffect.PILLEFFECT_IM_DROWSY -- 41
    end
  end
end

return RPPills
