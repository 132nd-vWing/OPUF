AIRBOSS.MenuF10Root=MENU_MISSION:New("Carrier Control").MenuPath
--AIRBOSS.MenuF10=MENU_MISSION:New("CVN STENNIS").MenuPath
--AIRBOSS.MenuF10=MENU_MISSION:New("CVN68 NIMITZ").MenuPath



--tanker
airboss_stennis_tanker= RECOVERYTANKER:New("CVN STENNIS", "TEXACO 2 #IFF:5112FR")
airboss_stennis_tanker:SetTakeoffHot()
airboss_stennis_tanker:SetRadio(242)
airboss_stennis_tanker:SetTACAN(40, "STN")
airboss_stennis_tanker:SetAltitude(8000)
airboss_stennis_tanker:SetSpeed(350)
airboss_stennis_tanker:Start()







--airboss
airboss_stennis = AIRBOSS:New("CVN STENNIS")


airboss_stennis:SetMenuRecovery(90, 15, true)



airboss_stennis:SetMaxFlightsPerStack(1)


airboss_stennis:SetSoundfilesFolder("Airboss Soundfiles/")


airboss_stennis:SetICLS(1,'C_S')
airboss_stennis:SetTACAN(74,X,'C_S')

airboss_stennis:SetMarshalRadio(305)
airboss_stennis:SetLSORadio(247.750)


airboss_stennis:SetRecoveryTanker(airboss_stennis_tanker)
airboss_stennis:SetDespawnOnEngineShutdown()


airboss_stennis:Start()

---------------------------------
--- Define Recovery Windows ---
---------------------------------

function airboss_stennis:OnAfterStart(From,Event,To)
  self:DeleteAllRecoveryWindows()
end



-- Current shift.
local shift=1

local function ChangeShift(airboss_stennis)
  local airboss_stennis=airboss_stennis --Ops.Airboss#AIRBOSS

  -- Next shift.
  shift=shift+1

  -- One cycle done. Next will be first shift.
  if shift==5 then
    shift=1
  end

  -- Set sound folder and voice over timings. 
  if shift==1 then
    env.info("Starting LSO/Marshal Shift 1: LSO Raynor, Marshal Raynor")
    airboss_stennis:SetVoiceOversLSOByRaynor()
    airboss_stennis:SetVoiceOversMarshalByRaynor()
  elseif shift==2 then
    env.info("Starting LSO/Marshal Shift 2: LSO FF, Marshal Raynor")
    airboss_stennis:SetVoiceOversLSOByFF("Airboss Soundpack LSO FF/")
    airboss_stennis:SetVoiceOversMarshalByRaynor()  
  elseif shift==3 then
    env.info("Starting LSO/Marshal Shift 3: LSO Raynor, Marshal FF")
    airboss_stennis:SetVoiceOversLSOByRaynor()
    airboss_stennis:SetVoiceOversMarshalByFF("Airboss Soundpack Marshal FF/")
  elseif shift==4 then
    env.info("Starting LSO/Marshal Shift 4: LSO FF, Marshal FF")
    airboss_stennis:SetVoiceOversLSOByFF("Airboss Soundpack LSO FF/")
    airboss_stennis:SetVoiceOversMarshalByFF("Airboss Soundpack Marshal FF/")
  end
 
end

-- Length of shift in minutes.
local L=30

-- Start shift scheduler to change shift every L minutes.
SCHEDULER:New(nil, ChangeShift, {airboss_stennis}, L*60, L*60)


--- Function called when recovery starts.
function airboss_stennis:OnAfterRecoveryStart(Event, From, To, Case, Offset)
local recoverymessage = string.format("CVN Stennis Starting Recovery Case %d ops.", Case)
  env.info(recoverymessage)
  MessageToAll(recoverymessage,15)
end
 

