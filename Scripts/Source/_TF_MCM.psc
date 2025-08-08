ScriptName _TF_MCM extends SKI_ConfigBase

; Properties
_TF_Spawner Property TF_Spawner Auto
GlobalVariable Property _TF_FalmerSpawnBaseChance Auto
GlobalVariable Property _TF_FalmerTimeLeft Auto

; Control IDs
int spawnChanceOID
int falmerTimeOID

Event OnConfigInit()
    ModName = "Treasure Falmers"
    Pages = new string[1]
    Pages[0] = "General Settings"
EndEvent

Event OnPageReset(string page)
    SetTitleText("Treasure Falmers Configuration")
    SetCursorFillMode(TOP_TO_BOTTOM)
    
    ; Spawn Probability Section
    AddHeaderOption("Spawn Settings")
    spawnChanceOID = AddSliderOption("Base Spawn Chance", _TF_FalmerSpawnBaseChance.GetValue(), "{0}%", OPTION_FLAG_NONE)
    
    ; Time Settings Section
    AddHeaderOption("Duration Settings")
    falmerTimeOID = AddSliderOption("Flee Timer", _TF_FalmerTimeLeft.GetValue(), "{0} seconds", OPTION_FLAG_NONE)
    
EndEvent

; Spawn Chance Slider
Event OnOptionSliderOpen(int option)
    if (option == spawnChanceOID)
        SetSliderDialogStartValue(_TF_FalmerSpawnBaseChance.GetValue())
        SetSliderDialogDefaultValue(100.0)    ; Default 1% chance
        SetSliderDialogRange(0.0, 100.0)   ; 0% to 100%
        SetSliderDialogInterval(1.0)       ; 1% increments
    elseif (option == falmerTimeOID)
        SetSliderDialogStartValue(_TF_FalmerTimeLeft.GetValue())
        SetSliderDialogDefaultValue(60.0)  ; Default 60 seconds
        SetSliderDialogRange(5.0, 600.0)   ; 5 sec to 10 min
        SetSliderDialogInterval(5.0)       ; 5 sec increments
    endif
EndEvent

Event OnOptionSliderAccept(int option, float value)
    if (option == spawnChanceOID)
        _TF_FalmerSpawnBaseChance.SetValue(value)
        SetSliderOptionValue(spawnChanceOID, value, "{0}%")
    elseif (option == falmerTimeOID)
        _TF_FalmerTimeLeft.SetValue(value)
        SetSliderOptionValue(falmerTimeOID, value, "{0} seconds")
    endif
EndEvent

event OnOptionHighlight(int option)
    if (option == spawnChanceOID)
        SetInfoText("Base chance for the system to find a suitable Treasure Falmer spawn point. Default: 100%")
    elseif (option == falmerTimeOID)
        SetInfoText("How long Treasure Falmers remain before disappearing. Default: 60s")

    endif

endevent