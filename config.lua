------------------------------------------------------------------------
-- Configuration for oUF_Porcelain
------------------------------------------------------------------------
local _, ns = ...
local oUF = ns.oUF or oUF
local cfg = {}
ns.cfg = cfg

-----------------------------
-- Colors and fonts
cfg.color = {
   health = {r =  0.3,  g =  0.3,   b =  0.3 },
   health_bg = {r =  0.3,  g =  0.3,   b =  0.3, a = 0.5 },
   castbar = {r =  0,   g =  0.7,   b =  1},
   GCD = {r =  0.55, g =  0.57,  b =  0.61},
   cPoints = {r =  1,   g =  0.96,  b =  0.41},
}

cfg.font = {
   normal = STANDARD_TEXT_FONT,
   number = STANDARD_TEXT_FONT,
}

cfg.texture ={
   statusbar = [[Interface\TARGETINGFRAME\UI-StatusBar]],
   backdrop = {
      bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
      edgeFile = [[Interface\ChatFrame\ChatFrameBackground]],
      edgeSize = 1,
      insets = { left = -1, right = -1, top = -1, bottom = -1}
  },
}

------------------------------------------------------------------------
-- Unitframes options
------------------------------------------------------------------------
-----------------------------
-- Enable/Disable units
cfg.uf = {
   raid = true,               -- Raid
   boss = true,               -- Boss
   party = true,              -- Party
   tank = true,               -- Maintank
   party_target = false,       -- Party target
   tank_target = true,        -- Maintank target
}

-----------------------------
-- Unit Frames Size
cfg.dimensions = {
   player = {
   --player, target, focus
      size = {250, 30},
      health = 30,
      power = 5,
      specific_power = 5,
   },
   --party, tank, arena, boss
   party = {
      size = {166, 20},
      health = 30,
      power = 3,
   },
   -- raid
   raid = {
      size = {60, 15},
      health = 30,
      power = 3,
   },
   --pet, targettarget, focustarget, arenatarget, partytarget, maintanktarget
   tot = {
      size = {90, 30},
   }
}

-----------------------------
-- Unit Frames Positions
cfg.unit_positions = {
   player =       { a = UIParent,            x= -260, y= 300},
   target =       { a = UIParent,            x= 260,  y= 300},
   targettarget = { a = 'oUF_PorcelainTarget',  x= 0,    y=  -64},
   focus =        { a = 'oUF_PorcelainPlayer',  x= -105, y=  300},
   focustarget =  { a = 'oUF_PorcelainFocus',   x= 95,   y=    0},
   pet =          { a = 'oUF_PorcelainPlayer',  x=   0,  y=  -64},
   boss =         { a = 'oUF_PorcelainTarget',  x=  100, y=  300},
   tank =         { a = 'oUF_PorcelainPlayer',  x= -105, y=  150},
   raid =         { a = UIParent,            x=  10, y=  -10},
   party =        { a = 'oUF_PorcelainPlayer',  x= -105, y=  150},
}

-----------------------------
-- Unit Frames Options
cfg.options = {
   class_colored = false,
   healcomm = true,
   specific_power = true,
   stagger_bar = true,
   cpoints = true,
   DruidMana = true,
   TotemBar = true,
   MushroomBar = true,
   disableRaidFrameManager = true,  -- disable default compact Raid Manager
}

cfg.AltPowerBar = {
   enable = true,
   pos = {'BOTTOM', UIParent, 0, 288},
   width = 250,
   height = 11,
}

cfg.EclipseBar = {
   enable = true,
   noTargetAlpha = 0.1,
   pos = {'BOTTOM', UIParent, 0, 200},
   width = 229,
   height = 11,
}

------------------------------------------------------------------------
-- Castbars
------------------------------------------------------------------------
cfg.castbar = {
   -- Player
   player_cb = {
      enable = true,
      pos = {'CENTER', UIParent, 13, -100},
      width = 290,
      height = 26,
   },
   -- Target
   target_cb = {
      enable = true,
      pos = {'BOTTOMRIGHT', 0, -23},
      height = 15,
      width = 234,
   },
   -- Boss
   boss_cb = {
      enable = true,
      pos = {'BOTTOMRIGHT', 0, -16},
      height = 15,
      width = 150,
   }
}