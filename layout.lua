------------------------------------------------------------------------
-- Layout itself of course
------------------------------------------------------------------------
local _, ns = ...
local oUF = ns.oUF or oUF
local _, class = UnitClass('player')
local cfg = ns.cfg

-----------------------------
-- Loading up the media
local backdrop = {
   bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
   insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local backdrop_1px = {
   bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
   insets = {top = -1, left = -1, bottom = -1, right = -1},
}

------------------------------------------------------------------------
-- Custom functions
------------------------------------------------------------------------
local function PostCreateAura(element, button)
  -- button.cd.noCooldownCount = true
  button:SetBackdrop(backdrop)
  button:SetBackdropColor(0, 0, 0)
  button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
  button.icon:SetDrawLayer('ARTWORK')
end

local function PostUpdateDebuff(element, unit, button, index)
  local _, _, _, _, type, _, _, owner = UnitAura(unit, index, button.filter)
  local color = DebuffTypeColor[type or 'none']
  button:SetBackdropColor(color.r * 3/5, color.g * 3/5, color.b * 3/5)
end

local OnEnter = function(self)
    UnitFrame_OnEnter(self)
    self.Highlight:Show()
end

local OnLeave = function(self)
    UnitFrame_OnLeave(self)
    self.Highlight:Hide()
end

------------------------------------------------------------------------
-- Unit Specific Layouts
------------------------------------------------------------------------
local UnitSpecific = {
   player = function(self, ...)
      self:SetSize(unpack(cfg.dimensions.player.size))
   end,

   target = function(self, ...)
      self:SetSize(unpack(cfg.dimensions.player.size))
   end,

   targettarget = function(self,...)
      self:SetSize(unpack(cfg.dimensions.tot.size))
   end,

   party = function(self,...)
      self:SetSize(unpack(cfg.dimensions.party.size))
   end,

   boss = function(self,...)
      self:SetSize(unpack(cfg.dimensions.player.size))
   end
}

-- UnitSpecific.raid = UnitSpecific.party  -- raid is equal to party
UnitSpecific.focus = UnitSpecific.targettarget
UnitSpecific.focustarget = UnitSpecific.targettarget
UnitSpecific.pet = UnitSpecific.targettarget
UnitSpecific.boss = UnitSpecific.targettarget

------------------------------------------------------------------------
-- Shared Layout part
------------------------------------------------------------------------
local Shared = function(self, unit, isSingle)
   -- turn "boss2" into "boss" for example
   unit = gsub(unit, "%d", "")

   self:SetScript('OnEnter', OnEnter)
   self:SetScript('OnLeave', OnLeave)


   self:RegisterForClicks"AnyUp"

   self:SetBackdrop(cfg.texture.backdrop)
   self:SetBackdropColor(0,0,0)

   -- You can safely remove this if you like bright mana
   self.colors.power.MANA = {0, 144/255, 1} -- I still find mana too bright

   ----------------------------------------
   -- Healthbar
   local hpBar = CreateFrame('StatusBar', nil, self)
   hpBar:SetStatusBarTexture(cfg.texture.statusbar)
   hpBar:SetHeight(40)
   hpBar:SetWidth(300)
   hpBar:SetPoint('TOP')
   hpBar:SetPoint('LEFT')
   hpBar:SetPoint('RIGHT')

   hpBar:SetStatusBarColor(.9, .9, .9)

   hpBar.frequentUpdates = true
   hpBar.colorTapping = true
   hpBar.colorDisconnected = true
   hpBar.colorClass = true
   hpBar.colorClassPet = true
   hpBar.colorReaction = true
   hpBar.colorSmooth = true
   hpBar.colorHealth = true

   local healthBackground = hpBar:CreateTexture(nil, 'BACKGROUND')
   healthBackground:SetPoint('TOPLEFT', hpBar, -1, 1)
   healthBackground:SetPoint('BOTTOMRIGHT', hpBar, 1, -1)
   healthBackground:SetTexture(cfg.texture.statusbar)
   -- healthBackground:SetVertexColor(.1, .1, .1)

   -- Make the background darker.
   healthBackground.multiplier = .3

   self.Health = hpBar
   self.Health.bg = healthBackground

   -----------------------------
   -- Powerbar

   -- Power.frequentUpdates = true

   -- Power.colorPower = true
   -- Power.colorClassNPC = true
   -- Power.colorClassPet = true


   -----------------------------
   -- Highlight
   self.Highlight = self.Health:CreateTexture(nil, 'OVERLAY')
   self.Highlight:SetAllPoints(self.Health)
   self.Highlight:SetTexture([=[Interface\Buttons\WHITE8x8]=])
   self.Highlight:SetVertexColor(1,1,1,.2)
   self.Highlight:SetBlendMode('ADD')
   self.Highlight:Hide()

   -----------------------------
   -- HealComms
   local myBar = CreateFrame('StatusBar', nil, self.Health)
   myBar:SetStatusBarTexture(cfg.statusbar)
   myBar:SetStatusBarColor(0.33, 0.59, 0.33, 0.6)
   myBar:SetWidth(self:GetWidth())
   myBar:SetPoint('TOP')
   myBar:SetPoint('BOTTOM')
   myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')

   local otherBar = CreateFrame("StatusBar", nil, self.Health)
   otherBar:SetStatusBarTexture(cfg.statusbar)
   otherBar:SetStatusBarColor(0.33, 0.59, 0.33, 0.6)
   otherBar:SetWidth(self:GetWidth())
   otherBar:SetPoint('TOP')
   otherBar:SetPoint('BOTTOM')
   otherBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')

   -- local absorbBar = createStatusbar(self.Health, cfg.texture, nil, nil, self:GetWidth(), 0.33, 0.59, 0.33, 0.6)
   -- absorbBar:SetPoint('TOP')
   -- absorbBar:SetPoint('BOTTOM')
   -- absorbBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')

   -- local healAbsorbBar = createStatusbar(self.Health, cfg.texture, nil, nil, self:GetWidth(), 0.33, 0.59, 0.33, 0.6)
   -- healAbsorbBar:SetPoint('TOP')
   -- healAbsorbBar:SetPoint('BOTTOM')
   -- healAbsorbBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')

   self.HealPrediction = {
      myBar = myBar,
      otherBar = otherBar,
      absorbBar = absorbBar,
      healAbsorbBar = healAbsorbBar,
      maxOverflow = 1,
      frequentUpdates = true,
   }

   ----------------------------------------
   -- Enable Plugins
   self.Range = {
      insideAlpha = 1,
      outsideAlpha = 0.5,
   }
   self.MoveableFrames = true

   -- leave this in!!
   if(UnitSpecific[unit]) then
      return UnitSpecific[unit](self)
   end
end

------------------------------------------------------------------------
-- Factory
------------------------------------------------------------------------
oUF:RegisterStyle('Porcelain', Shared)
oUF:Factory(function(self)
   self:SetActiveStyle('Porcelain')
   self:Spawn('player'):SetPoint('TOP', cfg.unit_positions.player.a, 'BOTTOM',cfg.unit_positions.player.x, cfg.unit_positions.player.y)
   self:Spawn('target'):SetPoint('TOP', cfg.unit_positions.target.a, 'BOTTOM', cfg.unit_positions.target.x, cfg.unit_positions.target.y)
   self:Spawn('targettarget'):SetPoint('RIGHT', cfg.unit_positions.targettarget.a, cfg.unit_positions.targettarget.x, cfg.unit_positions.targettarget.y)
   self:Spawn('focus'):SetPoint('RIGHT', cfg.unit_positions.focus.a, 'TOPLEFT', cfg.unit_positions.focus.x, cfg.unit_positions.focus.y)
   self:Spawn('focustarget'):SetPoint('TOPRIGHT', cfg.unit_positions.focustarget.a, cfg.unit_positions.focustarget.x, cfg.unit_positions.focustarget.y)
   self:Spawn('pet'):SetPoint('LEFT', cfg.unit_positions.pet.a, cfg.unit_positions.pet.x, cfg.unit_positions.pet.y)

   if cfg.uf.boss then
      for i = 1, MAX_BOSS_FRAMES do
         local boss = self:Spawn('Boss' .. i)
         boss:SetPoint('LEFT', cfg.unit_positions.boss.a, 'RIGHT', cfg.unit_positions.boss.x, cfg.unit_positions.boss.y - (51 * i))

         -- local blizzardFrames = _G['Boss' .. i .. 'TargetFrame']
         -- blizzardFrames:UnregisterAllEvents()
         -- blizzardFrames:Hide()
      end
   end

   -- Remove irrelevant rightclick menu entries
   for _, menu in pairs(UnitPopupMenus) do
      for i = #menu, 1, -1 do
         local name = menu[i]
         if name == "SET_FOCUS" or name == "CLEAR_FOCUS" or name:match("^LOCK_%u+_FRAME$") or name:match("^UNLOCK_%u+_FRAME$") or name:match("^MOVE_%u+_FRAME$") or name:match("^RESET_%u+_FRAME_POSITION") then
            tremove(menu, i)
         end
      end
   end
end)