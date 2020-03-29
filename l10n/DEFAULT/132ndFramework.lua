--assert(loadfile("D:\\_Google Drive\\DCS Missions\\132ndFramework.lua"))()
 
--CHANGE TO FALSE if disabling
ShirazCap = false
LarCap = true
KermanCap = true
AbbasCap = false

JiroftGCI = false
LarGCI = true
JaskGCI = false

--SQUADRON SIZES

LarNumbers = 12
AbbasNumbers = 12


--DONT CHANGE THESE SQN SIZES BECAUSE REASONS.
JiroftGCINumbers = 2
LarGCINumbers = 2
JaskGCINumbers = 2

--randomise flight numbers

function pickNumber() -- picks a random number of 1-4 with a weighting of 2 about 2/3rds of the time
local choose = math.random(1,100)
if choose < 6 then env.info("someone is a singleton") return 1
elseif choose >=6 and choose < 85 then env.info("someone is a 2ship") return 2
elseif choose >= 85 and choose < 95 then env.info("someone is a 3 ship") return 3
elseif choose >= 95 then env.info("someone is a fourship") return 4
end
end

-- DISPATCHER
DetectionSetGroup = SET_GROUP:New()
DetectionSetGroup:FilterPrefixes( { "IRAN AWACS#IFF:9001EN#001" , "COAST", "SHIRAZ EAST EWR", "SAM site 01", "66th_SA6_REGT_SA-6 Regiment_EWR", "KISH EWR", "BUSHER EWR", "Bandar Abbas EWR", "85th_SA3_REGT_EWR"} )
DetectionSetGroup:FilterStart()
CAPZone = ZONE:New( "CAPshiraz", "CAPshiraz" ) --is ignored
Detection = DETECTION_AREAS:New( DetectionSetGroup, 15000 ) --a 15km spread single invader package will be grouped as one detection event for response
A2ADispatcher = AI_A2A_DISPATCHER:New( Detection )
IranBorderZone = ZONE_POLYGON:New( "IranColdBorder", GROUP:FindByName( "IranColdBorder" ) )
A2ADispatcher:SetBorderZone( IranBorderZone )
A2ADispatcher:SetDisengageRadius( 460000 )--important to stop caps drifting 460km is 250nm, and covers coast from Shiraz to a bit east of Abbas 
A2ADispatcher:SetEngageRadius(200000) --everything inside 200km from the aircraft is handled by the CAP
A2ADispatcher:SetTacticalDisplay( false ) --change to false for production
A2ADispatcher:SetDefaultCapTimeInterval( 900, 1200 ) --between 15mins and 20mins
A2ADispatcher:SetDefaultFuelThreshold( 0.3 ) -- % including tanks before heading to refuel. Note refuel is on INTERNAL max only for AI.

--SQUADRONS + GCI
--SHIRAZ CAP
if ShirazCap == true then
A2ADispatcher:SetSquadron( "ShirazSqn", "Shiraz International Airport", ("Bogey-Shiraz") )
A2ADispatcher:SetSquadronOverhead( "ShirazSqn", 1 ) --1:1 equal match response
A2ADispatcher:SetSquadronGrouping( "ShirazSqn", pickNumber() )
A2ADispatcher:SetSquadronTakeoffFromParkingHot( "ShirazSqn" )
A2ADispatcher:SetSquadronLandingAtEngineShutdown( "ShirazSqn" )
A2ADispatcher:SetSquadronCap( "ShirazSqn", CAPZone, 5000, 9000, 600, 700, 600, 1000, "BARO", 0) --start disabled
A2ADispatcher:SetSquadronCapInterval( "ShirazSqn", 1, 900, 1200 ) -- only one CAP ever, between 15mins and 20mins
A2ADispatcher:SetSquadronTanker("ShirazSqn", "IranRefueller#001")
A2ADispatcher:SetSquadronCapRacetrack("ShirazSqn", UTILS.NMToMeters(20), UTILS.NMToMeters(20), 180, 180, nil, nil, {ZONE:New("CAPshiraz"):GetCoordinate()})
--GCI SAME SQN
A2ADispatcher:SetSquadronGci("ShirazSqn", 900, 1200 )

end

--LAR CAP (from Shiraz)
if LarCap ==true then
A2ADispatcher:SetSquadron( "ShirazSqn2", "Shiraz International Airport", ("Bogey-Lar") )
A2ADispatcher:SetSquadronOverhead( "ShirazSqn2", 1 ) --1:1 equal match response
A2ADispatcher:SetSquadronGrouping( "ShirazSqn2", pickNumber() )
A2ADispatcher:SetSquadronTakeoffFromParkingHot( "ShirazSqn2" )
A2ADispatcher:SetSquadronLandingAtEngineShutdown( "ShirazSqn2" )
A2ADispatcher:SetSquadronCap( "ShirazSqn2", CAPZone, 5000, 9000, 600, 700, 600, 1000, "BARO", LarNumbers) --CAPZone is ignored
A2ADispatcher:SetSquadronCapInterval( "ShirazSqn2", 1, 900, 1200 ) -- only one CAP ever, between 15mins and 20mins
--A2ADispatcher:SetSquadronTanker("ShirazSqn2", "IranRefueller#001") --f-5s?
A2ADispatcher:SetSquadronCapRacetrack("ShirazSqn2", UTILS.NMToMeters(20), UTILS.NMToMeters(20), 180, 180, nil, nil, {ZONE:New("CAPlar"):GetCoordinate()})
--GCI
--not from Lar
end

--LAR GCI ONLY
larOn = math.random(1,100)
if larOn <50 then 
LarGCI = false
A2ADispatcher:SetSquadron( "LarSqn", "Lar Airbase", ("Bogey-Lar") , LarGCINumbers )
A2ADispatcher:SetSquadronTakeoffFromParkingHot( "LarSqn" ) --does runway t/o work?
A2ADispatcher:SetSquadronLandingAtEngineShutdown( "LarSqn" )
A2ADispatcher:SetSquadronGci("LarSqn", 900, 1200 )
env.info("Lar GCI enabled")
else
env.info("Lar GCI disabled")
end

--KERMAN
if KermanCap ==true then
A2ADispatcher:SetSquadron( "KermanSqn", "Kerman Airport", ("Bogey-Kerman") )
A2ADispatcher:SetSquadronOverhead( "KermanSqn", 1 )
A2ADispatcher:SetSquadronGrouping( "KermanSqn", pickNumber() )
A2ADispatcher:SetSquadronTakeoffFromParkingHot( "KermanSqn" )
A2ADispatcher:SetSquadronLandingAtEngineShutdown( "KermanSqn" )
A2ADispatcher:SetSquadronCap( "KermanSqn", CAPZone, 5000, 9000, 600, 700, 600, 1000, "BARO" ,0) --start disabled
A2ADispatcher:SetSquadronCapInterval( "KermanSqn", 1, 900, 1200 ) -- only one CAP ever, between 15mins and 20mins
A2ADispatcher:SetSquadronTanker("KermanSqn", "IranRefueller#001")
A2ADispatcher:SetSquadronCapRacetrack("KermanSqn", UTILS.NMToMeters(20), UTILS.NMToMeters(20), 180, 180, nil, nil, {ZONE:New("CAPkerman"):GetCoordinate()})
--GCI INCLUDED
A2ADispatcher:SetSquadronGci("KermanSqn", 900, 1200 )

end

--ABBAS
if AbbasCap == true then
A2ADispatcher:SetSquadron( "AbbasSqn", "Bandar Abbas Intl", ("Bogey-Abbas") )
A2ADispatcher:SetSquadronOverhead( "AbbasSqn", 1 )
A2ADispatcher:SetSquadronGrouping( "AbbasSqn", pickNumber() )
A2ADispatcher:SetSquadronTakeoffFromParkingHot( "AbbasSqn" )
A2ADispatcher:SetSquadronLandingAtEngineShutdown( "AbbasSqn" )
A2ADispatcher:SetSquadronCap( "AbbasSqn", CAPZone, 5000, 9000, 600, 700, 600, 1000, "BARO", AbbasNumbers) 
A2ADispatcher:SetSquadronCapInterval( "AbbasSqn", 1, 900, 1200 ) -- only one CAP ever, between 15mins and 20mins
A2ADispatcher:SetSquadronTanker("AbbasSqn", "IranRefueller#001")
A2ADispatcher:SetSquadronCapRacetrack("AbbasSqn", UTILS.NMToMeters(20), UTILS.NMToMeters(20), 225, 225, nil, nil, {ZONE:New("CAPabbas"):GetCoordinate()})
--GCI not included (Jiroft)
end 

--JIROFT GCI ONLY
jiroftOn = math.random(1,100)
if jiroftOn < 50 then

A2ADispatcher:SetSquadron( "JiroftSqn", "Jiroft Airport", ("Bogey-Jiroft") , JiroftGCINumbers)
A2ADispatcher:SetSquadronTakeoffFromParkingHot( "JiroftSqn" ) --does runway t/o work?
A2ADispatcher:SetSquadronLandingAtEngineShutdown( "JiroftSqn" )
A2ADispatcher:SetSquadronGci("JiroftSqn", 900, 1200 )
env.info("Jiroft GCI enabled")
else
env.info("Jiroft GCI disabled")
end

--JASK GCI ONLY
if JaskGCI == true then
A2ADispatcher:SetSquadron( "JaskSqn", "Bandar-e-Jask airfield", ("Bogey-Jask") , JaskGCINumbers)
A2ADispatcher:SetSquadronTakeoffFromParkingHot( "JaskSqn" ) --does runway t/o work?
A2ADispatcher:SetSquadronLandingAtEngineShutdown( "JaskSqn" )
A2ADispatcher:SetSquadronGci("JaskSqn", 900, 1200 )
env.info("Jask GCI enabled")
end

--SCHEDULERS for swapsies (new group sizes and swap Kerman/Shiraz)
SCHEDULER:New( nil, function()
if ShirazCap == true then A2ADispatcher:SetSquadronCap( "ShirazSqn", CAPZone, 5000, 9000, 600, 700, 600, 1000, "BARO",0) end
if ShirazCap == true then A2ADispatcher:SetSquadronGrouping( "ShirazSqn", pickNumber() ) end
if KermanCap == true then A2ADispatcher:SetSquadronCap( "KermanSqn", CAPZone, 5000, 9000, 600, 700, 600, 1000, "BARO") end
if KermanCap == true then A2ADispatcher:SetSquadronGrouping( "KermanSqn", pickNumber() ) end
if LarCap == true then A2ADispatcher:SetSquadronGrouping( "ShirazSqn2", pickNumber() ) end
if AbbasCap == true then A2ADispatcher:SetSquadronGrouping( "AbbasSqn", pickNumber() ) end
end, {}, 0, 6200) --immediately, every 2hrs

SCHEDULER:New( nil, function()
if ShirazCap == true then A2ADispatcher:SetSquadronCap( "ShirazSqn", CAPZone, 5000, 9000, 600, 700, 600, 1000, "BARO") end
if ShirazCap == true then A2ADispatcher:SetSquadronGrouping( "ShirazSqn", pickNumber() ) end
if KermanCap == true then A2ADispatcher:SetSquadronCap( "KermanSqn", CAPZone, 5000, 9000, 600, 700, 600, 1000, "BARO",0) end
if KermanCap == true then A2ADispatcher:SetSquadronGrouping( "KermanSqn", pickNumber() ) end
if LarCap == true then A2ADispatcher:SetSquadronGrouping( "ShirazSqn2", pickNumber() ) end
if AbbasCap == true then A2ADispatcher:SetSquadronGrouping( "AbbasSqn", pickNumber() ) end
end, {}, 3600, 6200) --after 1 hour, every 2 hrs


