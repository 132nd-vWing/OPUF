local evasion = true     -- set to false to disable evasive behavior for Radar units
local chance_for_evasive_action = 85 -- percent chance that the Radar unit will take evasive action
local prefix = "evade_"  -- all SAM that should be added to the script need to have these word within their GROUP NAME
local Target_Smoke = false           -- set to TRUE if you want red smoke deployed from the Target SAM  (mainly used for debugging)
local evasion_delay = math.random(4,8)  -- after HARM launch, delay in seconds until the SAM take evasive action
local radar_delay = math.random(120,300)   -- time in seconds until the unit will turn its radar back on (random number between the two)
local move_distance =  math.random(50,150)-- meters the unit will move before stopping (random number between the two)
local evasion_for_client_planes_only = true -- set to false if Sam Radars should also respond to AI planes firing
local chance_for_group_relocating = 5   --percent chance that the group shuts down and moves to a new location further away
local relocating_distance = math.random(800,1200)  -- distance in meters that the group relocates


--- do not change below this line --- 













if evasion == true
then
  BASE:HandleEvent(EVENTS.Shot)

  local SEAD_enabled_Sams = SET_GROUP:New():FilterPrefixes(prefix)
  SEAD_enabled_Sams:FilterStart()

  _evadeRadars = {}  -- table that will be filled with all radar-containing units that are taking evasive action

  SEAD_enabled_Sams:ForEachGroupAlive(
    function(_group)
      Sam_group_name = _group:GetName()
      env.info("Sam GROUP Name is "..Sam_group_name)
      Sam_units = _group:GetUnits()
      for i,_unit in ipairs(Sam_units) do
        if
          _unit:HasAttribute("SAM SR") or _unit:HasAttribute("SAM TR")
        then
          env.info("Radar detected for unit ".._unit:GetName())
          table.insert(_evadeRadars,_unit:GetName())
        else
        end
      end
    end
  )
  if evasion_for_client_planes_only == true
  then
    function BASE:OnEventShot(EventData)
      local clientplane = EventData.IniPlayerName
      if clientplane ~= nil
      then
        env.info("a missile has been shot by "..clientplane)
        local SEAD_Weapon_Name = EventData.Weapon:getTypeName()
        if SEAD_Weapon_Name == "weapons.missiles.AGM_88" then
          local SEAD_Target = EventData.Weapon:getTarget()
          local SEAD_Target_Name = Unit.getName(SEAD_Target)
          local SEAD_Target_Unit = UNIT:FindByName(SEAD_Target_Name)
          local SEAD_Target_GROUP = SEAD_Target_Unit:GetGroup()
          local SEAD_Shooter_Unit = EventData.IniUnit
          local SEAD_Shooter_Name = SEAD_Shooter_Unit:GetName()
          for _,evasive_radar in pairs(_evadeRadars) do
            if evasive_radar == SEAD_Target_Name
            then
              env.info(SEAD_Shooter_Name.." has fired "..SEAD_Weapon_Name.." at "..SEAD_Target_Name)
              env.info("AGM_88 shot detected from  "..SEAD_Shooter_Name.." on "..SEAD_Target_Name)
              if math.random(1,100) <= chance_for_evasive_action
              then
                Radar_Unit_Evasive_Action(SEAD_Target_Unit)
              end
            end
          end
        end
      end
    end
  else
    function BASE:OnEventShot(EventData)
      local SEAD_Weapon_Name = EventData.Weapon:getTypeName()
      if SEAD_Weapon_Name == "weapons.missiles.AGM_88" then
        local SEAD_Target = EventData.Weapon:getTarget()
        local SEAD_Target_Name = Unit.getName(SEAD_Target)
        local SEAD_Target_Unit = UNIT:FindByName(SEAD_Target_Name)
        local SEAD_Target_GROUP = SEAD_Target_Unit:GetGroup()
        local SEAD_Shooter_Unit = EventData.IniUnit
        local SEAD_Shooter_Name = SEAD_Shooter_Unit:GetName()
        for _,evasive_radar in pairs(_evadeRadars) do
          if evasive_radar == SEAD_Target_Name
          then
            env.info(SEAD_Shooter_Name.." has fired "..SEAD_Weapon_Name.." at "..SEAD_Target_Name)
            env.info("AGM_88 shot detected from  "..SEAD_Shooter_Name.." on "..SEAD_Target_Name)
            if math.random(1,100) <= chance_for_evasive_action
            then
              Radar_Unit_Evasive_Action(SEAD_Target_Unit)
            end
          end
        end
      end
    end
  end

  function Radar_Unit_Evasive_Action(_unit) -- define the evasive action of the SAMsite when shot at by a HARM
    if Target_Smoke == true then
      _unit:SmokeRed()
  end
  env.info("Sam waiting "..evasion_delay.."seconds before taking evasive measure")
  SCHEDULER:New(nil,
    function()
      if  math.random(1,100) <= chance_for_group_relocating
      then
        env.info(_unit:GetName().."Air Defemse System now relocating "..relocating_distance.." meters")
        _unit:OptionAlarmStateGreen()
        local _groupcoordinate = _unit:GetCoordinate()
        local _tocoordinate = _groupcoordinate:Translate( relocating_distance, math.random(359) )
        local _ToCoord_vec2 = _tocoordinate:GetVec2()
        _unit:TaskRouteToVec2( _ToCoord_vec2 )
        _unit:OptionAlarmStateGreen()
        radarbackon = SCHEDULER:New(nil,
          function()
            _unit:OptionAlarmStateRed()
            env.info("radar back on")
          end,{},radar_delay)
      else
        env.info(_unit:GetName().." now taking evasive action")
        _unit:OptionAlarmStateGreen()
        local _groupcoordinate = _unit:GetCoordinate()
        local _tocoordinate = _groupcoordinate:Translate( move_distance, math.random(359) )
        local _ToCoord_vec2 = _tocoordinate:GetVec2()
        _unit:TaskRouteToVec2( _ToCoord_vec2 )
        _unit:OptionAlarmStateGreen()
        radarbackon = SCHEDULER:New(nil,
          function()
            _unit:OptionAlarmStateRed()
            env.info("radar back on")
          end,{},radar_delay)
      end
    end,{},evasion_delay)
  end
end
