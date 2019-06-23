--IADS RADAR SWITCHING
SamSet = SET_GROUP:New():FilterPrefixes("ADRDR"):FilterStart()

IADS1 =  SCHEDULER:New( nil, function()
        SamSet:ForEachGroup(
        function( MooseGroup )
        local chance = math.random(1,99)
            if chance > 50 then
              MooseGroup:OptionAlarmStateRed()
              ADUnit=MooseGroup:GetName()
              env.info("NSST: IADS - " ..ADUnit.. " is about to kill someone!")
            else
              MooseGroup: OptionAlarmStateGreen()
              ADUnit=MooseGroup:GetName()
              env.info("NSST: IADS - " ..ADUnit.. " is now in trolling mode.")
            end
        end)
end, {}, 5, 120)