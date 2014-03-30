------------------------------------------------------------------------
-- Namespace
------------------------------------------------------------------------
local _, ns = ...
local tags = oUF.Tags.Methods or oUF.Tags
local tagevents = oUF.TagEvents or oUF.Tags.Events

------------------------------------------------------------------------
-- Tags - Generic
------------------------------------------------------------------------
-----------------------------
-- Leader func
oUF.Tags.Methods['porc_leader'] = function(unit)
  if(UnitIsGroupLeader(unit)) then
    return '|cffffff00L|r'
  end
end
oUF.Tags.Events['porc_leader'] = 'PARTY_LEADER_CHANGED'

-----------------------------
-- colorize power
oUF.Tags.Events['porc_powercolor'] = 'UNIT_DISPLAYPOWER'
oUF.Tags.Methods['porc_powercolor'] = function(unit)
  local _, type = UnitPowerType(unit)
  local color = oUF.colors.power[type] or oUF.colors.power.FUEL
  return format('|cff%02x%02x%02x', color[1] * 255, color[2] * 255, color[3] * 255)
end

-----------------------------
-- colorize HP
oUF.Tags.Events['porc_unitcolor'] = 'UNIT_HEALTH UNIT_CLASSIFICATION UNIT_REACTION'
oUF.Tags.Methods['porc_unitcolor'] = function(unit)
  local color
  if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
    color = oUF.colors.disconnected
  elseif UnitIsPlayer(unit) then
    local _, class = UnitClass(unit)
    color = oUF.colors.class[class]
  elseif UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then
    color = oUF.colors.tapped
  elseif UnitIsEnemy(unit, 'player') then
    color = oUF.colors.reaction[1]
  else
    color = oUF.colors.reaction[UnitReaction(unit, 'player') or 5]
  end
  return color and ('|cff%02x%02x%02x'):format(color[1] * 255, color[2] * 255, color[3] * 255) or '|cffffffff'
end

-----------------------------
-- health func
oUF.Tags.Methods['porc_health'] = function(unit)
  if(not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit)) then return end

  local min, max = UnitHealth(unit), UnitHealthMax(unit)
  if(min ~= 0 and min ~= max) then
    return '-' .. ns.SI(max - min)
  else
    return ns.SI(max)
  end
end
oUF.Tags.Events['porc_health'] = oUF.Tags.Events.missinghp

-----------------------------
-- Shortname
oUF.Tags.Methods['porc_shortname'] = function(unit)
  local name = UnitName(unit)
  return (string.len(name) > 10) and string.gsub(name, '%s?(.)%S+%s', '%1. ') or name
end
oUF.Tags.Events['shortname'] = 'UNIT_NAME_UPDATE UNIT_REACTION UNIT_FACTION'

-----------------------------
-- PvP
oUF.Tags.Methods['porc_pvp'] = function (unit)
  if(UnitIsPVP(unit)) then
    return '|cffff0000#|r'
  end
end
oUF.Tags.Events['porc_pvp'] = oUF.Tags.Events.pvp

-----------------------------
-- Debuff tags - thanks to Tekkub
local function HasDebuffType(unit, t)
  for i=1,40 do
    local name, _, _, _, debuffType = UnitDebuff(unit, i)
    if not name then return
    elseif debuffType == t then return true end
  end
end

oUF.Tags.Methods["disease"] = function(u) return HasDebuffType(u, "Disease") and "|cff996600Di|r" end
oUF.Tags.Methods["magic"]   = function(u) return HasDebuffType(u, "Magic")   and "|cff3399FFMa|r" end
oUF.Tags.Methods["curse"]   = function(u) return HasDebuffType(u, "Curse")   and "|cff9900FFCu|r" end
oUF.Tags.Methods["poison"]  = function(u) return HasDebuffType(u, "Poison")  and "|cff009900Po|r" end
oUF.Tags.Events["disease"] = "UNIT_AURA"
oUF.Tags.Events["magic"]   = "UNIT_AURA"
oUF.Tags.Events["curse"]   = "UNIT_AURA"
oUF.Tags.Events["poison"]  = "UNIT_AURA"

-----------------------------
-- Boss Updates for HP - it's bugged in its current state, thus using zork's workaround
oUF.Tags.Methods["porc_bosshp"] = function(unit)
  local val = oUF.Tags.Methods["perhp"](unit)
  return val or ""
end
oUF.Tags.Events["porc_bosshp"] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_TARGETABLE_CHANGED"

-----------------------------
-- Alt Power
oUF.Tags.Methods['altpower'] = function(u)
  local cur = UnitPower(u, ALTERNATE_POWER_INDEX)
  local max = UnitPowerMax(u, ALTERNATE_POWER_INDEX)
  local name = select(10, UnitAlternatePowerInfo(u))
    local per = math.floor(cur/max*100+.5)
  if name and per > 0 then
        return(name..': '..'|cffAF5050'..format('%d%%', per))
    elseif name then
        return(name..': '..'|cffAF5050'..'0%')
    else
        return ('|cffAF5050'..'0%')
  end
end
oUF.Tags.Events['altpower'] = 'UNIT_POWER UNIT_MAXPOWER'

-----------------------------
-- Role designation
oUF.Tags.Methods['LFD'] = function(u)
  local role = UnitGroupRolesAssigned(u)
  if role == 'HEALER' then
    return '|cff8AFF30H|r'
  elseif role == 'TANK' then
    return '|cff5F9BFFT|r'
  elseif role == 'DAMAGER' then
    return '|cffFF6161D|r'
  end
end
oUF.Tags.Events['LFD'] = 'PLAYER_ROLES_ASSIGNED PARTY_MEMBERS_CHANGED'

------------------------------------------------------------------------
-- Tags - Class specific
------------------------------------------------------------------------
-----------------------------
-- Druid Power - show mana when not full
oUF.Tags.Methods['porc_druidpower'] = function(unit)
  local min, max = UnitPower(unit, 0), UnitPowerMax(unit, 0)
  if(UnitPowerType(unit) ~= 0 and min ~= max) then
    return ('|cff0090ff%d%%|r'):format(min / max * 100)
  end
end
oUF.Tags.Events['porc_druidpower'] = oUF.Tags.Events.missingpp

oUF.Tags.Methods['EclipseDirection'] = function(u)
    local direction = GetEclipseDirection()
  if direction == 'sun' then
    return '  '..' |cff4478BC>>|r'
  elseif direction == 'moon' then
    return '|cffE5994C<<|r '..'  '
  end
end
oUF.Tags.Events['EclipseDirection'] = 'UNIT_POWER ECLIPSE_DIRECTION_CHANGE'

