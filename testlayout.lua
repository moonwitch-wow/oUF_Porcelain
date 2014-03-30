local groups = { -- Change these to the global names your layout will make.
  party = {"oUF_PorcelainParty1", "oUF_PorcelainParty2", "oUF_PorcelainParty3", "oUF_PorcelainParty4"},
  -- arena = { "oUF_PorcelainArena1", "oUF_PorcelainArena2", "oUF_PorcelainArena3", "oUF_PorcelainArena4", "oUF_PorcelainArena5",  "oUF_PorcelainArenaPet1", "oUF_PorcelainArena2", "oUF_PorcelainArenaPet3", "oUF_PorcelainArenaPet4", "oUF_PorcelainArenaPet5" },
  boss = { "oUF_PorcelainBoss1", "oUF_PorcelainBoss2", "oUF_PorcelainBoss3", "oUF_PorcelainBoss4", "oUF_PorcelainBoss5" },
  focus = { "oUF_PorcelainFocus", "oUF_PorcelainFocusTarget"},
}

local function toggle(f)
  if f.__realunit then
    f:SetAttribute("unit", f.__realunit)
    f.unit = f.__realunit
    f.__realunit = nil
    f:Hide()
  else
    f.__realunit = f:GetAttribute("unit") or f.unit
    f:SetAttribute("unit", "player")
    f.unit = "player"
    f:Show()
  end
end

SLASH_OUFTEST1 = "/otest"
SlashCmdList.OUFTEST = function(group)
  local frames = groups[strlower(strtrim(group))]
  if not frames then return end
  for i = 1, #frames do
    local frame = _G[frames[i]]
    if frame then
      toggle(frame)
      print('frame exists: '..group..i)
    end
  end
end