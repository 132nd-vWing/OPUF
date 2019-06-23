--IADS RADAR SWITCHING
SamSet40 = SET_GROUP:New():FilterPrefixes("ADRRR"):FilterStart()

IADS2 =  SCHEDULER:New( nil, function()
        SamSet40:ForEachGroup(
        function( MooseGroup )
        local chance = math.random(1,99)
            if chance > 50 then
              MooseGroup:OptionAlarmStateRed()
              ADUnit=MooseGroup:GetName()
              env.info("NSST: IADS2 - " ..ADUnit.. " is about to kill someone!")
            else
              MooseGroup: OptionAlarmStateGreen()
              ADUnit=MooseGroup:GetName()
              env.info("NSST: IADS2 - " ..ADUnit.. " is now in trolling mode.")
            end
        end)
end, {}, 5, 40)